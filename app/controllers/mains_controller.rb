# encoding: utf-8
require "rubygems"
require "bundler/setup"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"
Capybara.run_server = false
Capybara.current_driver = :webkit
Capybara.app_host = "http://kuluttaja.etuovi.com/"
Capybara.default_wait_time = 5

class MainsController < ApplicationController
  include Capybara::DSL
  
  def home
    @results = []
    if params[:search_appartment]
      @results = get_results params[:search_appartment]
    else
      flash[:notice] = params
    end
  end
  
  private 
    
    def get_results(q)
      temp_list1 = []
      Capybara.app_host = "http://kuluttaja.etuovi.com/"
      visit('/')
      fill_in "fs_areafield", :with => q
      click_button "hae_pikahaku"
      wait_until { page.find('#container').visible? }
     
      all(:css, "table#searchList tr[style='background-color: #E9E9E9;']").each do |appartment| 
        a_hash = appartment.base.inner_html
        temp_list1.push a_hash
      end
      
      temp_list2 = []
      Capybara.app_host = "http://asunnot.oikotie.fi/"   
      visit('/')
      fill_in "magicbox", :with => q
      click_button "index-move-to-search"
      wait_until { page.find('#container').visible? }
      
      all(:css, "ul.cards li .content").each do |appartment|       
        a_hash = appartment.base.inner_html
        temp_list2.push a_hash
      end
      
#      temp_list3 = []
#      Capybara.app_host = "http://www.jokakoti.fi/etusivu"   
#      visit('/')
#      i = find(:css, '#searchbox .areapicker input')[0]
#      fill_in i, :with => q
#      button = find(:css, '#searchButtons :first-child :first-child')[0]
#      click_button button
#      wait_until { page.find('#maincontent').visible? }
#     
#      all(:css, "#searchResultsListPanel li").each do |appartment| 
#        a_hash = appartment.base.inner_html
#        temp_list3.push a_hash
#      end
#      
      return temp_list1, temp_list2
    end
end
