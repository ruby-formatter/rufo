module Rufo
  class DocPrinter
    ROOT_INDENT = {
      indent: 0,
      align: {
        spaces: 0,
      },
    }
    MODE_BREAK = 1
    MODE_FLAT = 2
    INDENT_WIDTH = 2
    class << self
      def print_doc_to_string(doc, opts)
        width = opts.fetch(:print_width)
        new_line = opts.fetch(:new_line, "\n")
        pos = 0

        cmds = [[ROOT_INDENT, MODE_BREAK, doc]]
        out = []
        should_remeasure = false
        line_suffix = []

        while cmds.length != 0
          x = cmds.pop
          puts x.inspect
          ind = x[0]
          mode = x[1]
          doc = x[2]
          if doc.is_a?(String)
            out.push(doc)
            pos += doc.length
          else
            puts doc.inspect
            case doc[:type]
            when :cursor
              out.push(doc[:placeholder])
            when :concat
              doc[:parts].reverse_each { |part| cmds.push([ind, mode, part]) }
            when :indent
              cmds.push([make_indent(ind), mode, doc[:contents]])
            when :align
              cmds.push([make_align(ind, doc[:n]), mode, doc[:contents]])
            when :group
              if mode == MODE_FLAT && !should_remeasure
                cmds.push([ind, doc[:break] ? MODE_BREAK : MODE_FLAT, doc[:contents]])
                next
              end
              if mode == MODE_FLAT || mode == MODE_BREAK
                should_remeasure = false
                next_cmd = [ind, MODE_FLAT, doc[:contents]]
                rem = width - pos

                if !doc[:break] && fits(next_cmd, cmds, rem)
                  cmds.push(next_cmd)
                else
                  unless doc[:expanded_states].nil?
                    most_expanded = doc[:expanded_states].last

                    if doc[:break]
                      cmds.push([ind, MODE_BREAK, most_expanded])
                      next
                    else
                      best_state = doc[:expanded_states].find { |state|
                        state_cmd = [ind, MODE_FLAT, state]
                        fits(state_cmd, cmds, rem)
                      } || most_expanded
                      cmds.push([ind, MODE_FLAT, best_state])
                    end
                  else
                    cmds.push([ind, MODE_BREAK, doc[:contents]])
                  end
                end
              end
            when :fill
              rem = width - pos
              parts = doc[:parts]
              next if parts.empty?

              content = parts[0]
              contents_flat_cmd = [ind, MODE_FLAT, content]
              contents_break_cmd = [ind, MODE_BREAK, content]
              content_fits = fits(contents_flat_cmd, [], width - rem, true)
              if parts.length == 1
                if content_fits
                  cmds.push(contents_flat_cmd)
                else
                  cmds.push(contents_break_cmd)
                end

                next
              end

              whitespace = parts[1]
              whitespace_flat_cmd = [ind, MODE_FLAT, whitespace]
              whitespace_break_cmd = [ind, MODE_BREAK, whitespace]
              if parts.length == 2
                if content_fits
                  cmds.push(whitespace_flat_cmd)
                  cmds.push(contents_flat_cmd)
                else
                  cmds.push(whitespace_break_cmd)
                  cmds.push(contents_break_cmd)
                end
                next
              end

              remaining = parts[2..-1]
              remaining_cmd = [ind, mode, DocBuilder::fill(remaining)]

              second_content = parts[2]
              first_and_second_content_flat_cmd = [
                ind, MODE_FLAT, DocBuilder::concat([content, whitespace, second_content]),
              ]
              first_and_second_content_fits = fits(
                first_and_second_content_flat_cmd,
                [],
                rem,
                true
              )

              if first_and_second_content_fits
                cmds.push(remaining_cmd)
                cmds.push(whitespace_flat_cmd)
                cmds.push(contents_flat_cmd)
              elsif content_fits
                cmds.push(remaining_cmd)
                cmds.push(whitespace_break_cmd)
                cmds.push(contents_flat_cmd)
              else
                cmds.push(remaining_cmd)
                cmds.push(whitespace_break_cmd)
                cmds.push(contents_break_cmd)
              end
            when :if_break
              if mode === MODE_BREAK
                if doc[:break_contents]
                  cmds.push([ind, mode, doc[:break_contents]])
                end
              end
              if mode === MODE_FLAT
                if doc[:flat_contents]
                  cmds.push([ind, mode, doc[:flat_contents]])
                end
              end
            when :line_suffix
              line_suffix.push([ind, mode, doc[:contents]])
            when :line_suffix_boundary
              if line_suffix.length > 0
                cmds.push([ind, mode, {type: :line, hard: true}])
              end
            when :line
              if mode == MODE_FLAT
                unless doc[:hard]
                  unless doc[:soft]
                    out.push(" ")
                    pos += 1
                  end
                  next
                else
                  should_remeasure = true
                end
              end
              if mode == MODE_FLAT || mode == MODE_BREAK
                unless line_suffix.empty?
                  cmds.push([ind, mode, doc])
                  cmds.concat(line_suffix.reverse)
                  line_suffix = []
                  next
                end

                if doc[:literal]
                  out.push(new_line)
                  pos = 0
                else
                  if out.length > 0
                    while out.length > 0 && out.last.match?(/^[^\S\n]*$/)
                      out.pop
                    end

                    unless out.empty?
                      out[-1] = out.last.sub(/[^\S\n]*$/, "")
                    end
                  end

                  length = ind[:indent] * INDENT_WIDTH + ind[:align][:spaces]
                  indent_string = " " * length
                  out.push(new_line, indent_string)
                  pos = length
                end
              end
            end
          end
        end

        cursor_place_holder_index = out.index(DocBuilder::CURSOR[:placeholder])

        if cursor_place_holder_index
          before_cursor = out[0..(cursor_place_holder_index-1)].join("")
          after_cursor = out[(cursor_place_holder_index+1)..-1].join("")

          return {
                   formatted: before_cursor + after_cursor,
                   cursor: before_cursor.length,
                 }
        end

        {formatted: out.join("")}
      end

      private

      def make_indent(ind)
        {
          indent: ind[:indent] + 1,
          align: ind[:align],
        }
      end

      def make_align(ind, n)
        return ROOT_INDENT if n == -Float::INFINITY
        {
          indent: ind[:indent],
          align: {
            spaces: ind[:align][:spaces] + n,
          },
        }
      end

      def fits(next_cmd, rest_cmds, width, must_be_flat = false)
        rest_idx = rest_cmds.size
        cmds = [next_cmd]

        while width >= 0
          if cmds.size == 0
            return true if (rest_idx == 0)
            cmds.push(rest_cmds[rest_idx - 1])

            rest_idx -= 1
            next
          end

          x = cmds.pop
          ind = x[0]
          mode = x[1]
          doc = x[2]

          if doc.is_a?(String)
            width -= doc.length
          else
            case doc[:type]
            when :concat
              doc[:parts].each { |part| cmds.push([ind, mode, part]) }
            when :indent
              cmds.push(make_indent(ind), mode, doc[:contents])
            when :align
              cmds.push([make_align(ind, doc[:n]), mode, doc[:contents]])
            when :group
              return false if must_be_flat && doc[:break]
              cmds.push([ind, doc[:break] ? MODE_BREAK : mode, doc[:contents]])
            when :fill
              doc[:parts].each { |part| cmds.push([ind, mode, part]) }
            when :if_break
              if mode == MODE_BREAK && doc[:break_contents]
                cmds.push([ind, mode, doc[:break_contents]])
              elsif mode == MODE_FLAT && doc[:flat_contents]
                cmds.push([ind, mode, doc[:flat_contents]])
              end
            when :line
              case mode
              when MODE_FLAT
                unless doc[:hard]
                  unless doc[:soft]
                    width -= 1
                  end
                else
                  return true
                end
              when MODE_BREAK
                return true
              end
            end
          end
        end

        return false
      end
    end
  end
end
