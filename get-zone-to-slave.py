#!/usr/bin/python

import MySQLdb

##
## Define database information
##
DB_HOST = 'localhost'
DB_USER = 'admin'
DB_PASS = '$AES-128-CBC$M8r6KCqmwCeH3pauuNQkXg==$UMoHiEi/w2vRtkoWCBzCHQ=='
DB_NAME = 'psa'

##
## You have to define from which server are you getting the following domains
##
MASTER_DNS = '74.208.113.7'

def run_query(query=''):
    datos = [DB_HOST, DB_USER, DB_PASS, DB_NAME]

    conn = MySQLdb.connect(*datos)	# Connect to database
    cursor = conn.cursor()		# Create a cursor
    cursor.execute(query)		# Execute a query

    if query.upper().startswith('SELECT'):
	data = cursor.fetchall()
    else:
	conn.commit()
	data = None

    cursor.close()
    conn.close()

    return data

def escribe_dom(dom1):
#  archivo = open ("/home/linuxar/doms.txt", "wyy)
  contenido = archivo.read()
  final_del_archivo = archivo.tell()
  archivo.write('zone \"'+dom1+'\" {\n')
  archivo.write('  type slave;\n')
  archivo.write('  file \"slaves/'+dom1+'\";\n')
  archivo.write('  masters {\n')
  archivo.write('    '+MASTER_DNS+';\n')
  archivo.write('  };\n')
  archivo.write('};\n\n')
  archivo.seek(final_del_archivo)
  nuevo_contenido = archivo.read()


query = "SELECT DISTINCT name FROM dns_zone WHERE status='0';"
result = run_query(query)

#for zone in result:
#  dom1 = zone[0]
#  print "zone \""+dom1+"\" {"
#  print "  type slave;"
#  print "  file \"slaves/"+dom1+"\";"
#  print "  masters {"
#  print "    "+MASTER_DNS+";"
#  print "  };"
#  print "};"
#  print ""

archivo = open ("/home/linuxar/doms.txt", "w+")

for zone in result:
  escribe_dom(zone[0])
