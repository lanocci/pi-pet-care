# coding: utf-8
require 'mysql'
require 'gruff'
require 'date'

HOME_PATH = '/home/pi/'
PROJECT_PATH = HOME_PATH + 'Projects/pi-pet-care/'
GRAPH_PATH = PROJECT_PATH + 'graph/'

class Create_Chart

  def initialize
  end


  def get_data_from_tmpr_tbl column_name
    con = Mysql::new('127.0.0.1', 'toto', 'P@ssword01')
    ary = Array.new
#    selectSql = "SELECT ID, " + column_name + " FROM PET_CARE.TEMPARATURE ORDER BY ID"
#    puts selectSql
    tmp = con.query("select id, " + column_name + " from pet_care.temparature order by id")
    return tmp
  end  
  
  def get_temparature_ary
    temparature = Array.new
    tmp = get_data_from_tmpr_tbl("temparature")
    tmp.each do |row|
      temparature.push(row[1].to_f)
    end
    return temparature
  end

  def get_timestamp_ary
    timestamp = Array.new
    tmp = get_data_from_tmpr_tbl("updated_at")
    tmp.each do |row|
      timestamp.push(DateTime.parse(row[1].to_s))
    end
    return timestamp
  end
  
  def create_gruff_image
    g = Gruff::Line.new 500
    g.title = "Hedgehouse Temparature"
    g.theme_keynote
    g.minimum_value = 10
    g.maximum_value = 35
    g.y_axis_increment = 5
    tmp_ary = get_temparature_ary
    time_ary = get_timestamp_ary
    g.data :temparature, tmp_ary
    time_ary.each_with_index do |time, i|
      if time.hour == 0 && time.min.between?(0, 14)
        g.labels[i] = time.strftime('%m/%d')
      elsif time.hour == 12 && time.min.between?(0,14)
        g.labels[i] = ('12:00')
      end
    end
    g.write("#{GRAPH_PATH}temparature_graph.png")
    
  end


end

cc = Create_Chart.new
cc.create_gruff_image

