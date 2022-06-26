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
  arena = intel.dig('arena', 'state')
  my_location = arena.dig(my_href)

  # F <- move Forward
  # R <- turn Right
  # L <- turn Left
  # T <- Throw

  if my_location['wasHit']
    ['F', 'L', 'R'].sample
  else
    # Attack
    my_direction = my_location['direction']
    case my_direction
    when 'N'
      strike_location = 'y'
      strike_range = (my_location[strike_location]-3...my_location[strike_location])
    when 'S'
      strike_location = 'y'
      strike_range = (my_location[strike_location]+1..my_location[strike_location]+3)
    when 'E'
      strike_location = 'x'
      strike_range = (my_location[strike_location]+1..my_location[strike_location]+3)
    when 'W'
      strike_location = 'x'
      strike_range = (my_location[strike_location]-3...my_location[strike_location])
    end

    if arena.any? {|enemy| strike_range.include?(enemy[1][strike_location]) }
      'T'
    else
      ['F', 'L', 'R'].sample
    end
  end
end
