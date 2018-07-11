#! /usr/bin/env ruby
#encoding: utf-8

require 'csv'
require 'json'

file=ARGV[0]
output=ARGV[1]

options={:col_sep=>";",encoding: 'UTF-8:UTF-8',:headers => true};

csv=CSV.read(file,options)

_map={}
n=0
csv.headers.each do |h|
#   puts h

   if h==nil

   elsif  h.include? "Q.S."
      _map[:qs]=n
   elsif h.include?"P.Q."
      _map[:pq]=n
   elsif h.include?"P.L.Q."
      _map[:plq]=n
   elsif h.include?"C.A.Q."
      _map[:caq]=n
   end
   n+=1
end

#puts partis

#  parse le header

others=[
   "% QS/total",
   "% PQ/total",
   "% PLQ/total",
   "% CAQ/total",
   "% QS/votes",
   "% PQ/votes",
   "% PLQ/votes",
   "% CAQ/votes",
   "% votes",
   "vainqueur"
]

headers=csv.headers

others.each do |item|
   headers.push(item)
end

out={"headers": headers}
out["data"]=[]

csv.each do |line|
   t=[]
   line.each do |item|
      t.push(item[1]) # récupère la valeur
   end

   nqs=line[_map[:qs]].to_f
   npq=line[_map[:pq]].to_f
   nplq=line[_map[:plq]].to_f
   ncaq=line[_map[:caq]].to_f

   # pourcent-total-qs
   val=nqs
   tot=line["É.I."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_total_qs]=t.length-1

   # pourcent-total-pq
   val=npq
   tot=line["É.I."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_total_pq]=t.length-1


   # pourcent-total-plq
   val=nplq
   tot=line["É.I."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_total_plq]=t.length-1

   # pourcent-total-caq
   val=ncaq
   tot=line["É.I."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_total_caq]=t.length-1

   # pourcent-total-qs
   val=nqs
   tot=line["B.V."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_vote_qs]=t.length-1

   # pourcent-total-pq
   val=npq
   tot=line["B.V."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_vote_pq]=t.length-1

   # pourcent-total-plq
   val=nplq
   tot=line["B.V."].to_f
   t.push((val/tot)*100)
   _map[:ourcent_vote_plq]=t.length-1

   # pourcent-total-caq
   val=ncaq
   tot=line["B.V."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_vote_caq]=t.length-1

   # % vote
   tot=line["É.I."].to_f
   val=line["B.V."].to_f
   t.push((val/tot)*100)
   _map[:pourcent_vote]=t.length-1


   # vainqueur

   if (nqs<npq) && (nqs<nplq)&& (nqs<ncaq)
       t.push(1)
   elsif (npq<nqs) && (npq<nplq)&& (npq<ncaq)
       t.push(2)
   elsif (nplq<npq) && (nplq<nqs)&& (nplq<ncaq)
       t.push(3)
   elsif (ncaq<npq) && (ncaq<nplq)&& (ncaq<nqs)
       t.push(4)
   else
      t.push(-1)
   end
   _map[:vainqueur]=t.length-1


   valid=true
   t.each do |val,idx|
      if((val.to_f.nan?))
         valid=false
      end
      if((val.to_f.infinite?))
         valid=false
      end

   end

   if valid==true
      out["data"].push(t)
   end
end

out["map"]=_map

File.open(output, 'w') do |f|
   f.puts out.to_json
end
