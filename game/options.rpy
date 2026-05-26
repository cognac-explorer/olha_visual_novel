init python:
    config.name = "Ольха"
    config.version = "1.0.0"
    config.screen_width  = 720
    config.screen_height = 1280
    config.developer = False
    config.save_directory = "olha-game"
    config.rollback_enabled = True
    config.auto_load = "auto-1"
    if renpy.emscripten:
        config.savedir = "/home/web_user/.renpy/" + config.save_directory
    preferences.text_cps = 40

    build.classify("renpy-8.5.2-sdk/**", None)
    build.classify("docs/**", None)
    build.classify("tmp_build_*/**", None)
    build.classify("**.zip", None)
    build.classify("**.docx", None)
    build.classify("Спрайты/**", None)

    build.archive("archive", "all")
