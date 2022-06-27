require 'sinatra'

$stdout.sync = true

configure do
  set :port, 8080
  set :bind, '0.0.0.0'
end

get '/' do
  'Let the battle begin!'
end

post '/' do
  intel = JSON.parse(request.body.read)
  puts intel

  my_href = intel.dig('_links', 'self', 'href')
  arena = intel.dig('arena')
  arena_state = arena.dig('state')
  my_location = arena_state.dig(my_href)
  arena_grid = arena.dig('dims')

  # F <- move Forward
  # R <- turn Right
  # L <- turn Left
  # T <- Throw

  # Attack
  my_direction = my_location['direction'] # N/S/E/W
  case my_direction
  when 'N'
    strike_direction = 'y'
    strike_range = (my_location[strike_direction]-3...my_location[strike_direction])
  when 'S'
    strike_direction = 'y'
    strike_range = (my_location[strike_direction]+1..my_location[strike_direction]+3)
  when 'E'
    strike_direction = 'x'
    strike_range = (my_location[strike_direction]+1..my_location[strike_direction]+3)
  when 'W'
    strike_direction = 'x'
    strike_range = (my_location[strike_direction]-3...my_location[strike_direction])
  end

  ['R', 'L', 'F', 'T'].sample

  # Go to the top row
  # if arena_state.any? { |enemy| strike_range.include?(enemy[1][strike_direction]) }
  #   'T'
  # else
  #   if (my_location['direction'] != 'N' && my_location['y'] != 0)
  #     ['R', 'L'].sample
  #   else
  #     if my_location['y'] != 0
  #       'F'
  #     else # On the top row
  #       # Turn 'S'
  #       if my_location['direction'] == 'N'
  #         ['R', 'L'].sample
  #       else
  #         if arena_state.any? { |enemy| strike_range.include?(enemy[1][strike_direction]) }
  #           'T'
  #         else
  #           ['F', 'R', 'L'].sample
  #         end
  #       end
  #     end
  #   end
  # end
end
