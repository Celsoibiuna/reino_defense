from sqlalchemy import Column, Integer, String, Float
from database import Base

class Profissional(Base):
    __tablename__ = "profissionais"

    id = Column(Integer, primary_key=True)
    nome = Column(String)
    categoria = Column(String)
    latitude = Column(Float)
    longitude = Column(Float)
    avaliacao = Column(Float)
    disponibilidade = Column(Integer)