from database import SessionLocal
from models import Profissional

def criar_profissional(prof):
    db = SessionLocal()
    novo = Profissional(**prof.dict())
    db.add(novo)
    db.commit()
    db.refresh(novo)
    return novo

def listar_profissionais():
    db = SessionLocal()
    return db.query(Profissional).all()