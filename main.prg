compiler_options _use_cstyle_matrix;
program Unbalance;
        
const
     dbPath = "db/config.db";
end

typedef
    type __screen
        int width;
        int height;
        int bpp;
        int flagsmode;
    end
    
    type __direcional
        int cruceta[3][3];
    end
    
    type __botones
        int start;
        int select;
        int aceptar;
        int cancelar;
    end
    
    type __control
        __direcional direccional;
        __botones botones;
    end
end

global
    int DBHandlder;
  __control controlJugador;


BEGIN
    setearPantalla();
    LOOP
        FRAME;
    END
END

function string existeArchivo(string path, string mensaje)
BEGIN
  if( not file_exists(dbPath) )
    exit(mensaje);
  end
  return true;
END

function int prerararDB()
BEGIN
  if(DBHandler != 0)
      return DBHandler;
  end
  existeArchivo(dbPath, "No Existe la base de datos.");
  if (!DBHandlder = db_open(dbPath, dbms_sqlite, db_readonly))
    exit("Error al conectar a la base de datos");
  end
  return DBHandlder;
END

function consultarDB(pointer DBQuery, pointer DBResult, string query)
//DBHandler = variable global
BEGIN
  DBHandler = prerararDB();
  &DBQuery = db_query(DBHandler, query, false);
  &DBResult = dbquery_evaluate(DBQuery);
END

function __screen consultarResolcionEnDB(string query)
    private
        __screen screen;
        int DBQuery;
        int DBResult;
        string dbPath;
    end
BEGIN
    ConsultarDB(&DBQuery, &DBResult, query);
    DBQUERY_GET_VALUE(DBResult, 1, &screen.width );
    DBQUERY_GET_VALUE(DBResult, 2, &screen.height );
    DBQUERY_GET_VALUE(DBResult, 3, &screen.bpp );
    DBQUERY_GET_VALUE(DBResult, 4, &screen.flagsmode );
    return screen;
END

function __screen obtenerResolucion()
//arma la query y devuelve la resolucion.
BEGIN
  query = "select r.width, r. height, r.bpp, r.flagsmode from resolution r inner join config c on c.resolution = r.id";
 
  return consultarResolcionEnDB(string query);
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
    set_mode(screen.width, screen.height, screen.bpp, screen.flagsmode);
END



