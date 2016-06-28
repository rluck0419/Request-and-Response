require_relative '../db/setup'
require_relative '../lib/user'
# Remember to put the requires here for all the classes you write and want to use

def parse_params(uri_fragments, query_param_string)
  params = {}
  params[:resource]  = uri_fragments[3]
  params[:id]        = uri_fragments[4]
  params[:action]    = uri_fragments[5]
  if query_param_string
    param_pairs = query_param_string.split('&')
    param_k_v   = param_pairs.map { |param_pair| param_pair.split('=') }
    param_k_v.each do |k, v|
      params.store(k.to_sym, v)
    end
  end
  params
end
# You shouldn't need to touch anything in these methods.
def parse(raw_request)
  pieces = raw_request.split(' ')
  method = pieces[0]
  uri    = pieces[1]
  http_v = pieces[2]
  route, query_param_string = uri.split('?')
  uri_fragments = route.split('/')
  protocol = uri_fragments[0][0..-2]
  full_url = uri_fragments[2]
  subdomain, domain_name, tld = full_url.split('.')
  params = parse_params(uri_fragments, query_param_string)
  return {
    method: method,
    uri: uri,
    http_version: http_v,
    protocol: protocol,
    subdomain: subdomain,
    domain_name: domain_name,
    tld: tld,
    full_url: full_url,
    params: params
  }
end
def display(user)
  puts "Name: #{user.first_name} #{user.last_name}, Age: #{user.age}"
end
def delete(params, users)
  user = params[:id].to_i
  index = user - 1
  puts "200 OK"
  puts
  puts "User ##{user} (#{users[index].first_name} #{users[index].last_name}) has been removed from the user list."
  users.delete_at(index)
end
def display_each(users)
  users.count.times do |i|
    display(users[i])
  end
end

def display_each_first(users, params)
  users.count.times do |i|
    if users[i].first_name[0].downcase == params[:first_name]
      display(users[i])
    end
  end
end

def first_or_full(users, params)
  if params[:first_name].nil?
    display_each(users)
  else
    display_each_first(users, params)
  end
end


user01 = User.new("Rob", "Bor", 23)
user02 = User.new("Bob", "Bob", 40)
user03 = User.new("Gob", "Bog", 30)
user04 = User.new("Tom", "Mot", 25)
user05 = User.new("Tim", "Mit", 19)
user06 = User.new("Jim", "Mij", 35)
user07 = User.new("Pam", "Map", 50)
user08 = User.new("Jan", "Naj", 42)
user09 = User.new("Sam", "Mas", 28)
user10 = User.new("Zed", "Dez", 25)
user11 = User.new("Ted", "Det", 48)
user12 = User.new("Syd", "Dys", 37)
user13 = User.new("Lee", "Eel", 25)
user14 = User.new("Zoe", "Eoz", 38)
user15 = User.new("Jud", "Duj", 43)
user16 = User.new("Mat", "Tam", 26)
user17 = User.new("Jon", "Noj", 21)
user18 = User.new("Bil", "Lib", 48)
user19 = User.new("Lin", "Nil", 58)
user20 = User.new("Rey", "Yer", 52)
user21 = User.new("Stu", "Uts", 66)
users = [user01, user02, user03, user04, user05,
  user06, user07, user08, user09, user10,
  user11, user12, user13, user14, user15,
  user16, user17, user18, user19, user20,
  user21
]


system('clear')
loop do
  print "Supply a valid HTTP Request URL (h for help, q to quit) > "
  raw_request = gets.chomp

  case raw_request
  when 'q' then puts "Goodbye!"; exit
  when 'h'
    puts "A valid HTTP Request looks like:"
    puts "\t'GET http://localhost:3000/students HTTP/1.1'"
    puts "Read more at : http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html"
  else
    @request = parse(raw_request)
    @params  = @request[:params]
    # Use the @request and @params ivars to full the request and
    # return an appropriate response

    # YOUR CODE GOES BELOW HERE
    if @request[:method] == "GET"
      if @params[:resource] == "users"
        if @params[:id].nil?
          puts "200 OK"
          puts
          if @params[:limit].nil?
            if @params[:offset].nil?
              first_or_full(users, @params)
            else
              shifted_users = users[@params[:offset].to_i..-1]
              first_or_full(shifted_users, @params)
            end
          else
            if @params[:offset].nil?
              if @params[:first_name].nil?
                @params[:limit].to_i.times do |i|
                  display(users[i])
                end
              else
                @params[:limit].to_i.times do |i|
                  if users[i].first_name[0].downcase == @params[:first_name]
                    display(users[i])
                  end
                end
              end
            else
              shifted_users = users[@params[:offset].to_i..-1]
              if @params[:first_name].nil?
                @params[:limit].to_i.times do |i|
                  display(shifted_users[i])
                end
              else
                @params[:limit].to_i.times do |i|
                  if users[i].first_name[0].downcase == @params[:first_name]
                    display(shifted_users[i])
                  end
                end
              end
            end
          end
        elsif (1..20).include?(@params[:id].to_i)
          puts "200 OK"
          puts
          display(users[@params[:id].to_i - 1])
        else
          puts "INVALID REQUEST - 404 NOT FOUND"
          puts
        end
      end
    elsif @request[:method] == "DELETE"
      delete(@params, users)
    end
    # YOUR CODE GOES ABOVE HERE  ^
  end
end

# methods for GET, DELETE, nil?'s
# getting info separate from puts at end
# filtering later before puts
