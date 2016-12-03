require 'time'
load 'twitter-ruby.rb'
load 'login.rb'
load 'colorize.rb'

#class Object;def length;self.size rescue nil;end;end

def sysputs(s);$stdout<<"[CrunchyrollGiftCodeBot] ".light_blue<< s<<0xa.chr;end

t = TwitterAPI::autoConstruct
sysputs "Authorized TwitterAPI".green
sysputs "Sending search query...".yellow
res = JSON.parse t.search("q"=>%q+Crunchyroll+, "lang"=>"de", "count"=>100).body
sysputs "Got response from Search API".green
filtered = res["statuses"].map do |i|
	[i["text"],i["created_at"],i["user"]["screen_name"]]
end.select do |i|
	i[0].match(/[0-9A-Z]{11}/)!=nil
end.select do |i|
	i[0].match(/^RT @/)==nil
end
def resetLastMatch;/x/=~"x";end   # sets variable $` to 0
filtered.map! do |status|
	resetLastMatch
	codes = []
	buf = status[0]
	while !(buf.match(/[0-9A-Z]{11}/).nil? rescue true)
		buf = buf.slice($`.length,buf.length)
		codes << [buf.slice(0, 11), status[1], status[2]]
		buf = buf.slice($`.length+11, buf.length)
	end
	codes
end.uniq!

unless filtered.empty?
	puts "The following gift codes were found:".green
	for code in filtered
		t = Time.now-Time.parse(code[0][1])
		puts "#{code[0][0].light_blue} (posted: "+code[0][1].yellow+"  "+"|".light_blue+" #{"%02i"%((t/60/60).to_i)}h #{"%02i"%((t/60).to_i%60)}m #{"%02i"%(t.to_i%60)}s ago, by ".yellow+"@#{code[0][2]}".light_blue+")"
	end
else
	puts "No gift codes found. (the Twitter API cannot find tweets that are older than one week)".red
end
