from pydantic import BaseModel

class ProfissionalCreate(BaseModel):
    nome: str
    categoria: str
    latitude: float
    longitude: float
    avaliacao: float
    disponibilidade: int
    