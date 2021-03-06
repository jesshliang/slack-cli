#!/usr/bin/env ruby

require 'httparty'
require 'table_print'

require_relative 'workspace'

def main
  puts "Welcome to the Ada Slack CLI!"
  workspace = SlackCLI::Workspace.new
  puts "#{ workspace.channels.length } channels loaded.."
  puts "#{ workspace.users.length } users loaded.."
  
  continue = true
  until continue == false
    puts "What would you like to do ?\n1. List users\n2. List channels\n3. Select user\n4. Select channel\n5. Details\n6. Send message\n7. Quit"
    choice = gets.chomp.downcase

    if ["1", "list users"].include?(choice)
      puts "*"
      tp workspace.users, :name, :real_name, :slack_id
      puts "*"

    elsif ["2", "list channels"].include?(choice)
      puts "*"
      tp workspace.channels, :name, :topic, :member_count, :slack_id
      puts "*"

    elsif ["3", "select user"].include?(choice)
      puts "What USER would you like to select?"
      workspace.select_user(gets.chomp)
      
      if workspace.selected != nil
        puts "******\nSelected user: #{ workspace.selected.name }\n******"
      end

    elsif ["4", "select channel"].include?(choice)
      puts "What CHANNEL would you like to select?"
      workspace.select_channel(gets.chomp)
      
      if workspace.selected != nil
        puts "******\nSelected channel: #{ workspace.selected.name }\n******"
      end

    elsif ["5", "details"].include?(choice)
      puts "******"
      if workspace.selected.class == SlackCLI::User
        tp workspace.show_details, :name, :real_name, :slack_id
      elsif workspace.selected.class == SlackCLI::Channel
        tp workspace.show_details, :name, :topic, :member_count, :slack_id
			else
				puts "Nothing has been selected to show details."
      end
      puts "******"

    elsif ["6", "send message", "message", "send"].include?(choice)
      if workspace.selected != nil
				puts "What message would you like to send to the selected user/channel?"
				workspace.send_message(gets.chomp)
			else
				raise ArgumentError.new("No user or channel has been chosen to send a message.")
      end
      
    elsif ["7", "quit", "exit", "q"].include?(choice)
      continue = false

    else
      puts "Please choice an option above."
    end
  end

  puts "Thank you for using the Ada Slack CLI"
end

main if __FILE__ == $PROGRAM_NAME