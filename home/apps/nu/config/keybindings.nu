export def main [] {
  return [
    {
      name: completion_menu
      modifier: none
      keycode: tab
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menu name: completion_menu }
          { send: menunext }
          { edit: complete }
        ]
      }
    }
    {
      name: ide_completion_menu
      modifier: control
      keycode: char_n
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menu name: ide_completion_menu }
          { send: menunext }
          { edit: complete }
        ]
      }
    }
    # replaced by Atuin.sh
    # {
    #   name: history_menu
    #   modifier: control
    #   keycode: char_r
    #   mode: [vi_insert, vi_normal]
    #   event: { send: menu name: history_menu }
    # }
    {
      name: help_menu
      modifier: none
      keycode: f1
      mode: [vi_insert, vi_normal]
      event: { send: menu name: help_menu }
    }
    {
      name: completion_previous_menu
      modifier: shift
      keycode: backtab
      mode: [vi_normal, vi_insert]
      event: { send: menuprevious }
    }
    {
      name: escape
      modifier: none
      keycode: escape
      mode: [vi_normal, vi_insert]
      # NOTE: does not appear to work
      event: { send: esc }
    }
    {
      name: cancel_command
      modifier: control
      keycode: char_c
      mode: [vi_normal, vi_insert]
      event: { send: ctrlc }
    }
    {
      name: quit_shell
      modifier: control
      keycode: char_d
      mode: [vi_normal, vi_insert]
      event: { send: ctrld }
    }
    {
      name: clear_screen
      modifier: control
      keycode: char_l
      mode: [vi_normal, vi_insert]
      event: { send: clearscreen }
    }
    {
      name: search_history
      modifier: control
      keycode: char_q
      mode: [vi_normal, vi_insert]
      event: { send: searchhistory }
    }
    {
      name: open_command_editor
      modifier: control
      keycode: char_o
      mode: [vi_normal, vi_insert]
      event: { send: openeditor }
    }
    {
      name: move_up
      modifier: none
      keycode: up
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menuup }
          { send: up }
        ]
      }
    }
    {
      name: move_down
      modifier: none
      keycode: down
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menudown }
          { send: down }
        ]
      }
    }
    {
      name: move_left
      modifier: none
      keycode: left
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menuleft }
          { send: left }
        ]
      }
    }
    {
      name: move_right_or_take_history_hint
      modifier: none
      keycode: right
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: historyhintcomplete }
          { send: menuright }
          { send: right }
        ]
      }
    }
    {
      name: move_one_word_left
      modifier: control
      keycode: left
      mode: [vi_normal, vi_insert]
      event: { edit: movewordleft }
    }
    {
      name: move_one_word_right_or_take_history_hint
      modifier: control
      keycode: right
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: historyhintwordcomplete }
          { edit: movewordright }
        ]
      }
    }
    {
      name: move_to_line_start
      modifier: none
      keycode: home
      mode: [vi_normal, vi_insert]
      event: { edit: movetolinestart }
    }
    {
      name: move_to_line_start
      modifier: control
      keycode: char_a
      mode: [vi_normal, vi_insert]
      event: { edit: movetolinestart }
    }
    {
      name: move_to_line_end_or_take_history_hint
      modifier: none
      keycode: end
      mode: [vi_normal, vi_insert]
      event: {
          until: [
              { send: historyhintcomplete }
              { edit: movetolineend }
          ]
      }
    }
    {
      name: move_to_line_end_or_take_history_hint
      modifier: control
      keycode: char_e
      mode: [vi_normal, vi_insert]
      event: {
          until: [
              { send: historyhintcomplete }
              { edit: movetolineend }
          ]
      }
    }
    {
      name: move_to_line_start
      modifier: control
      keycode: home
      mode: [vi_normal, vi_insert]
      event: { edit: movetolinestart }
    }
    {
      name: move_to_line_end
      modifier: control
      keycode: end
      mode: [vi_normal, vi_insert]
      event: { edit: movetolineend }
    }
    {
      name: move_up
      modifier: control
      keycode: char_p
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menuup }
          { send: up }
        ]
      }
    }
    {
      name: move_down
      modifier: control
      keycode: char_t
      mode: [vi_normal, vi_insert]
      event: {
        until: [
          { send: menudown }
          { send: down }
        ]
      }
    }
    {
      name: delete_one_character_backward
      modifier: none
      keycode: backspace
      mode: [vi_insert]
      event: { edit: backspace }
    }
    {
      name: delete_one_word_backward
      modifier: control
      keycode: backspace
      mode: [vi_insert]
      event: { edit: backspaceword }
    }
    {
      name: delete_one_character_forward
      modifier: none
      keycode: delete
      mode: [vi_insert]
      event: { edit: delete }
    }
    {
      name: delete_one_character_forward
      modifier: control
      keycode: delete
      mode: [vi_insert]
      event: { edit: delete }
    }
    {
      name: delete_one_character_backward
      modifier: control
      keycode: char_h
      mode: [vi_insert]
      event: { edit: backspace }
    }
    {
      name: delete_one_word_backward
      modifier: control
      keycode: char_w
      mode: [vi_insert]
      event: { edit: backspaceword }
    }
    {
      name: move_left
      modifier: none
      keycode: backspace
      mode: vi_normal
      event: { edit: moveleft }
    }
    {
      name: cut_line_from_start
      modifier: control
      keycode: char_u
      mode: [vi_normal, vi_insert]
      event: { edit: cutfromstart }
    }
    {
      name: copy_selection
      modifier: control_shift
      keycode: char_c
      mode: emacs
      event: { edit: copyselectionsystem }
    }
    {
      name: cut_selection
      modifier: control_shift
      keycode: char_x
      mode: emacs
      event: { edit: cutselectionsystem }
    }
    {
      name: paste_system
      modifier: control_shift
      keycode: char_v
      mode: emacs
      event: { edit: pastesystem }
    }
    {
      name: select_all
      modifier: control_shift
      keycode: char_a
      mode: emacs
      event: { edit: selectall }
    }
  ]
}
