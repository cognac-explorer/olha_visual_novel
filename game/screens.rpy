## screens.rpy — Custom UI screens

screen stat_hud():
    zorder 100
    modal False

    frame:
        xalign 0.95
        yalign 0.05
        xpadding 20
        ypadding 12
        background Frame("#000000aa", 8, 8)

        vbox:
            spacing 4
            text "── Характеристики ──" font "font.ttf" size 22 color "#aaaacc" bold True
            text "Мудрость: [mudrost]" font "font.ttf" size 24 color "#88ddff"
            text "Влияние: [vliyanie]" font "font.ttf" size 24 color "#aaffaa"
            text "Мстительность: [mstelnost]" font "font.ttf" size 24 color "#ffaaaa"
            text "Христианство: [hristianstvo]" font "font.ttf" size 24 color "#ffcc88"

style say_dialogue:
    font "font.ttf"
    size 28
    color "#ffffff"
    outlines [ (1, "#000", 0, 0) ]
    text_align 0.5
    xalign 0.5

screen say(who, what):
    frame:
        id "window"
        xalign 0.5
        xsize 660
        yalign 1.0
        yoffset -20
        background Frame("images/simple_textbox.png", 60, 70, 60, 70)
        padding (60, 70, 60, 70)

        vbox:
            spacing 8
            if who:
                text who:
                    font "font.ttf"
                    size 26
                    color "#c89020"
                    bold True
            text what id "what":
                style "say_dialogue"

screen confirm(message, yes_action, no_action):
    modal True

    add "#000000bb"

    frame:
        xalign 0.5
        yalign 0.4
        xpadding 60
        ypadding 40
        background Frame("#1a1a2eee", 12, 12)

        vbox:
            spacing 30
            xalign 0.5

            text message:
                font "font.ttf"
                size 28
                color "#eeeecc"
                xalign 0.5
                text_align 0.5

            hbox:
                xalign 0.5
                spacing 60

                textbutton _("Да"):
                    action yes_action
                    text_font "font.ttf"
                    text_size 26
                    text_color "#88ddff"

                textbutton _("Нет"):
                    action no_action
                    text_font "font.ttf"
                    text_size 26
                    text_color "#ffaaaa"

    key "game_menu" action no_action

init python:
    config.overlay_screens.append("stat_hud")
    config.confirm_screen = True
