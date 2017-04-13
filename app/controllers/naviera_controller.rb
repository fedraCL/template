class NavieraController < ApplicationController
  before_action :authenticate_user!
  
  def parseHTML_APL(page)
    doc = Nokogiri::HTML(page)
   # puts doc
    #titulos
    table = doc.css('table')

    routing = table[2]
    container = table[3]
    puts "===========================================================" 

    # get table headers
    headers = []
    routing.css('th').each do |th|
      headers << th.text
    end
   # puts headers.to_s


    # get table rows
    rows = []
    routing.css('tr').each_with_index do |row, i|

      rows[i] = {}
      row.xpath('td').each_with_index do |td, j|
        rows[i][headers[j]] = td.text
      end
    end

    rows.each do |fila|
      puts fila
    end

    @resultado  = rows
    render :json => @resultado
    
  end
  
  def parseHTML_CMA(page)
    doc = Nokogiri::HTML(page)

    #titulos
    table = doc.xpath('//table[@id="container-moves"]')
    #puts table.to_s

    #routing = table[2]
    container = table[0]
    puts "tabla = " + container.to_s
    
    if container!=nil
      
    
    puts "===========================================================" 

    # get table headers
    headers = []
    container.css('th').each do |th|
      headers << th.text
    end
    puts headers.to_s

    # get table rows
    rows = []
    container.css('tr').each_with_index do |row, i|

      rows[i] = {}
      row.xpath('td').each_with_index do |td, j|
        rows[i][headers[j]] = td.text
      end
    end

    rows.each do |fila|
      puts fila
    end

    @resultado  = rows
    render :json => @resultado
  else
    @resultado  = rows
    render :json => nil
  end
  end
  
  def apl
    puts "Iniciando WS APL"
    container = params[:container]
    p container.to_s
    
    #A sacar datos de APL
    
    require 'net/http'
    require 'nokogiri'
    require 'pp'
  
    Net::HTTP.start("homeport.apl.com") do |http|
        resp = http.get("/gentrack/trackingMain.do?trackInput01="+container)
        cookie = resp.response['set-cookie'].split('; ')[0]
    
        headers = {
          'Cookie' => cookie,
          'Content-Type' => 'application/x-www-form-urlencoded'
        }
    
    
        open("page.html", "wb") do |file|
      
            resp1 = http.get("/gentrack/containerTrackingFrame.do",headers)
          #  file.write(resp1.body)
          parseHTML_APL(resp1.body)
        end
    end

    
  end
  
  def  cma
    puts "llegue"
    
    require 'net/http'
    require 'nokogiri'
    require 'pp'
    container = params[:container]
    Net::HTTP.start("www.cma-cgm.com") do |http|
        resp = http.get("/ebusiness/tracking/search?SearchBy=Container&Reference="+container+"&search=Search")
        puts "esto trae: " + resp.body
          parseHTML_CMA(resp.body)
    end
  end
  
  def getDetails(url)
    p "Buscando detalle : " + url
    p url
  
    response = Net::HTTP.get_response(URI(url))
    parseDetails(response.body)
  
  end

  def parseDetails(page)
    #p "detalle :: " + page.to_s
    doc = Nokogiri::HTML(page)
    data =  doc.css("div.row.param")
    #data =  doc.xpath("id('ais-data')")
  
  
    resultado = {}
  
  
    data.each do |dato|
      a = dato.to_s.gsub(/<\/?[^>]*>/, "")
      dataok = a.to_s.chop!.strip
    
      values = dataok.split(":")
    
     # p  values[0].to_s.strip + ":"  + values[1].to_s.strip
    
      resultado[values[0].to_s.strip] = values[1].to_s.strip
    
   
    end
  
    return resultado
  

  end




  def parseHTML_vessel(page)
      r = {}
    doc = Nokogiri::HTML(page)
    #puts doc
    #titulos
    table = doc.css('article')
    #puts table.to_s
  
    i = 0
    table.each do |barco|
      puts "barco ================" + i.to_s
      #p barco.to_s
      links = barco.css('a')
      c = 0
      #link para ubicación
  
      trozo =   links[1]
      doc1 = Nokogiri::HTML(trozo.to_s.gsub(/\s/, ' '))
      l = doc1.css('a').map { |link| link['href'] }
   
    
      #get details
    
      l.each do |ll|
     #   p ll
        url = "https://www.vesselfinder.com" + ll
        p getDetails(url).to_s
        r = r.merge(getDetails(url))
      end
    
    
    
      i = i +1
    end
    @resultado  = r
    render :json => @resultado
  
  end
  
  def get_response_with_redirect(uri)
     r = Net::HTTP.get_response(uri)
     if r.code == "301"
       r = Net::HTTP.get_response(URI.parse(r.header['location']))
     end
     r
  end
  
  
  def vessel
    
    vessel = params[:vessel]
    response = Net::HTTP.get_response(URI('https://www.vesselfinder.com/vessels?name='+vessel))
    parseHTML_vessel(response.body)
  end
  
  
  def nyk
    require "net/http"
    require 'net/https'
    require "uri"
    require 'json'

    cop_no = ""
    id_container = params[:container]

    #https://www.nykline.com/ecom/CUP_HOM_3301GS.do?_search=false&rows=10000&page=1&sidx=&sord=asc&f_cmd=121&search_type=A&search_name=DRYU9475289&cust_cd=

    

    #primero buscamos cop_no
    cop_no = cop_no(id_container)

    uri = URI.parse("https://www.nykline.com/ecom/CUP_HOM_3301GS.do")
    https = Net::HTTP.new("www.nykline.com",443)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)

    data = {
      "f_cmd" => "125",
      "cntr_no" => id_container,
      "bkg_no" => "",
      "cop_no"=> cop_no
    }

    req.set_form_data(data)
    res = https.request(req)

    salida  = JSON.parse(res.body)
    @resultado = salida
    render :json => @resultado
    puts salida
    
  end
  
  def cop_no(container)
    puts "buscando cop no"
    Net::HTTP.start("www.nykline.com") do |http|
        resp = http.get("/ecom/CUP_HOM_3301GS.do?_search=false&rows=10000&page=1&sidx=&sord=asc&f_cmd=121&search_type=A&search_name="+container+"&cust_cd=")
     
        data_hash = JSON.parse(resp.body)
        puts data_hash['list'][0]['copNo']
        return data_hash['list'][0]['copNo']
      end

  end
  
end
