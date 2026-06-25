import mysql.connector


class Singleton(type):
    _instances = {}

    def __call__(cls, *args, **kwargs):
        if cls not in cls._instances:
            cls._instances[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls._instances[cls]


class MySQLDB(metaclass=Singleton):
    def __init__(self, db_config: dict):
        self.conn = mysql.connector.connect(
            host=db_config["host"],
            port=int(db_config["port"]),
            database=db_config["database"],
            user=db_config["user"],
            password=db_config["password"],
        )

    def get_conn(self):
        return self.conn
