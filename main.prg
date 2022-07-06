  program Unbalance;
const
     dbPath = "db/config.db";
end

typedef
    type __screen
        int width;
        int height;
        int bpp;
    end

end

global
  int DBHanlder;
end

function string existeArchivo(string path, string mensaje)
BEGIN
  if( not file_exists(dbPath) )
    exit(mensaje);
  end
  return true;
END

function int prerararDB()
BEGIN
  existeArchivo(dbPath, "No Existe la base de datos.");
  if (!DBHanlder = db_open(dbPath, dbms_sqlite, db_readonly))
    exit("Error al conectar a la base de datos");
  end
  return DBHanlder;
END

function consultarDB(pointer DBQuery, pointer DBResult, string query)
BEGIN
  DBHandler = prerararDB();
  DBQuery = db_query(DBHandler, query, false);
  DBResult = dbquery_evaluate(queryID);
END

function __screen obtenerResolucion()
    private
        __screen screen;
        int DBHandler;
        int DBQuery;
        int DBResult;
        string dbPath;
        string query;
    end
BEGIN
  query =   "select r.width,
            r. height,
            r.bpp
            from resolution
            inner join config c
            on c.resolution = r.id";
  ConsultarDB(&DBQuery, &DBResult, query);
  DBQUERY_GET_VALUE(DBResult, 1, &screen.width );
  DBQUERY_GET_VALUE(DBResult, 2, &screen.height );
  DBQUERY_GET_VALUE(DBResult, 3, &screen.bpp );
  return screen;
END

function setearPantalla()
         private
             __screen screen;
         end
BEGIN
    screen = obtenerResolucion();
    if(!mode_exists(screen.width, screen.height, screen.bpp) )
        exit("modo no soportado");
    end
    set_mode(screen.width, screen.height, screen.bpp);
END


BEGIN
    setearPantalla();
    LOOP
        FRAME;
    END
END
