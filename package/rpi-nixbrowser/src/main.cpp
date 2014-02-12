#include <glib.h>
#include <iostream>
#include <cstring>
#include <cassert>

#include <WebKit2/WKContext.h>
#include <WebKit2/WKNumber.h>
#include <WebKit2/WKPage.h>
#include <WebKit2/WKPageGroup.h>
#include <WebKit2/WKString.h>
#include <WebKit2/WKType.h>
#include <WebKit2/WKURL.h>
#include <WebKit2/WKView.h>
#include <WebKit2/WKPreferences.h>
#include <WebKit2/WKPreferencesPrivate.h>

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES2/gl2.h>

#include <bcm_host.h>

struct state {
    uint32_t screen_width;
    uint32_t screen_height;

    EGLDisplay display;
    EGLSurface surface;
    EGLContext context;
};

struct state g_state;
static bool scheduleUpdate = false;

static void ogl_init(struct state *state)
{
    int32_t success;
    EGLBoolean result;
    EGLint num_config;

    static EGL_DISPMANX_WINDOW_T nativewindow;

    DISPMANX_ELEMENT_HANDLE_T dispman_element;
    DISPMANX_DISPLAY_HANDLE_T dispman_display;
    DISPMANX_UPDATE_HANDLE_T dispman_update;
    VC_RECT_T dst_rect;
    VC_RECT_T src_rect;

    static const EGLint attribute_list[] = {
        EGL_RED_SIZE, 8,
        EGL_GREEN_SIZE, 8,
        EGL_BLUE_SIZE, 8,
        EGL_ALPHA_SIZE, 8,
        EGL_SURFACE_TYPE, EGL_WINDOW_BIT,
        EGL_NONE
    };

    EGLConfig config;

    // We need call eglMakeCurrent beforehand to workaround a bug on rPi.
    // https://github.com/raspberrypi/firmware/issues/99
    eglMakeCurrent(0, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    state->display = eglGetDisplay(EGL_DEFAULT_DISPLAY);
    assert(state->display != EGL_NO_DISPLAY);

    result = eglInitialize(state->display, NULL, NULL);
    assert(result != EGL_FALSE);

    /* Get an appropriate EGL frame buffer config. */
    result = eglChooseConfig(state->display, attribute_list, &config, 1, &num_config);
    assert(result != EGL_FALSE);

    result = eglBindAPI(EGL_OPENGL_ES_API);
    assert(EGL_FALSE != result);

    static const EGLint context_attributes[] = {
        EGL_CONTEXT_CLIENT_VERSION, 2,
        EGL_NONE
    };
    state->context = eglCreateContext(state->display, config, EGL_NO_CONTEXT, context_attributes);
    assert(state->context != EGL_NO_CONTEXT);

    success = graphics_get_display_size(0 /* LCD */, &state->screen_width, &state->screen_height);
    assert(success >= 0);

    /* Prepare VideoCore specific nativewindow to create a window surface. */
    dst_rect.x = 0;
    dst_rect.y = 0;
    dst_rect.width = state->screen_width;
    dst_rect.height = state->screen_height;

    src_rect.x = 0;
    src_rect.y = 0;
    src_rect.width = state->screen_width << 16;
    src_rect.height = state->screen_height << 16;

    dispman_display = vc_dispmanx_display_open(0 /* LCD */);
    dispman_update = vc_dispmanx_update_start(0);

    dispman_element = vc_dispmanx_element_add(dispman_update, dispman_display,
                                              0 /* layer */, &dst_rect, 0 /* src */, &src_rect,
                                              DISPMANX_PROTECTION_NONE, 0 /* alpha */,
                                              0 /* clamp */, DISPMANX_TRANSFORM_T(0) /* transform */);

    nativewindow.element = dispman_element;
    nativewindow.width = state->screen_width;
    nativewindow.height = state->screen_height;

    vc_dispmanx_update_submit_sync(dispman_update);

    state->surface = eglCreateWindowSurface(state->display, config, &nativewindow, NULL);
    assert(state->surface != EGL_NO_SURFACE);

    result = eglMakeCurrent(state->display, state->surface, state->surface, state->context);
    assert(result != EGL_FALSE);
    assert(glGetError() == 0);
}

static void ogl_exit(struct state *state)
{
    eglMakeCurrent(state->display, EGL_NO_SURFACE, EGL_NO_SURFACE, EGL_NO_CONTEXT);
    eglDestroySurface(state->display, state->surface);
    eglDestroyContext(state->display, state->context);
    eglTerminate(state->display);
}
static int scheduledDisplayUpdate(void * data)
{
    WKViewRef webView = static_cast<WKViewRef>(data);
    scheduleUpdate = false;
    eglMakeCurrent(g_state.display,g_state.surface, g_state.surface, g_state.context);
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    WKViewPaintToCurrentGLContext(webView);
    eglSwapBuffers(g_state.display, g_state.surface);
    return 0;
}

static void viewNeedsDisplay(WKViewRef webView, WKRect, const void*)
{
    if(scheduleUpdate)
        return;
    scheduleUpdate = true;
    // 40 fps
    g_timeout_add(25, scheduledDisplayUpdate, (gpointer)webView);
}

static void didReceiveTitleForFrame(WKPageRef page, WKStringRef title, WKFrameRef, WKTypeRef, const void*)
{
    char buffer[256];
    size_t size = WKStringGetUTF8CString(title, buffer, sizeof(buffer) - 1);
    buffer[size] = 0;
    std::cout << "Title: " << buffer << "\n";
}

int main(int argc, char* argv[])
{
    const char* url = argc == 2 ? argv[1] : "http://www.google.com";

    bcm_host_init();

    memset(&g_state, 0, sizeof(struct state));
    ogl_init(&g_state);

    GMainLoop* mainLoop = g_main_loop_new(0, false);
    WKContextRef context = WKContextCreate();
    WKViewRef webView = WKViewCreate(context, NULL);
    WKPageRef page = WKViewGetPage(webView);

    WKPreferencesRef webPreferences = WKPageGroupGetPreferences(WKPageGetPageGroup(page));
    WKPreferencesSetWebGLEnabled(webPreferences, true);
    WKPreferencesSetDeveloperExtrasEnabled(webPreferences, true);

    WKViewClientV0 viewClient;
    memset(&viewClient, 0, sizeof(WKViewClientV0));
    viewClient.base.version = 0;
    viewClient.base.clientInfo = NULL;
    viewClient.viewNeedsDisplay = viewNeedsDisplay;
    WKViewSetViewClient(webView, &viewClient.base);

    WKViewInitialize(webView);

    WKPageLoaderClientV3 loaderClient;
    memset(&loaderClient, 0, sizeof(WKPageLoaderClientV3));
    loaderClient.base.version = 3;
    loaderClient.base.clientInfo = NULL;
    loaderClient.didReceiveTitleForFrame = didReceiveTitleForFrame;
    WKPageSetPageLoaderClient(page, &loaderClient.base);

    WKViewSetSize(webView, WKSizeMake(g_state.screen_width, g_state.screen_height));
    WKPageLoadURL(page, WKURLCreateWithUTF8CString(url));

    g_main_loop_run(mainLoop);

    WKRelease(webView);
    WKRelease(context);
    g_main_loop_unref(mainLoop);

    ogl_exit(&g_state);

    return 0;
}
