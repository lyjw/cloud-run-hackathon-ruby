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
  arena_grid = arena.dig('dims') # "dims"=>[13, 9]

  # F <- move Forward
  # R <- turn Right
  # L <- turn Left
  # T <- Throw

  # Attack
  my_direction = my_location['direction']
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
  return 'T' if arena_state.any? { |enemy| strike_range.include?(enemy[1][strike_direction]) }

  arena_border = strike_direction == 'x' ? arena_grid[0] : arena_grid[1]

  if my_direction.in?(%w(E S)) && ((my_location['x'] == 0) && (my_location['y'] == 0)) ||
    my_direction.in?(%w(N W)) && ((my_location['x'] == arena_grid[0]-1) && (my_location['y'] == arena_grid[1]-1)) ||
    my_direction.in?(%w(N E)) && ((my_location['x'] == 0) && (my_location['y'] == arena_grid[1]-1)) ||
    my_direction.in?(%w(S W)) && ((my_location['x'] == arena_grid[0]-1) && (my_location['y'] == 0)
    return 'F'
  end

  if ([0, arena_border-1].include?(my_location[strike_direction]))
    ['R', 'L'].sample
  else
    if (Array(1..10).sample % 3).zero?
      ([0, arena_border-1].include?(my_location[strike_direction])) ? ['R', 'L'].sample : ['F', 'R', 'L'].sample
    end
      'F'
    end
  end
end
