from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="KeroPro API")

# Libera acesso do Flutter Web
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def home():
    return {"mensagem": "API KeroPro online"}

@app.get("/profissionais")
def listar_profissionais():
    return [
        {
            "id": 1,
            "nome": "Joao Silva",
            "categoria": "Eletricista",
            "avaliacao": 4.9,
            "disponibilidade": 1,
            "latitude": -23.55,
            "longitude": -47.44
        },
        {
            "id": 2,
            "nome": "Carlos Souza",
            "categoria": "Encanador",
            "avaliacao": 4.8,
            "disponibilidade": 1,
            "latitude": -23.54,
            "longitude": -47.43
        },
        {
            "id": 3,
            "nome": "Marcos Lima",
            "categoria": "Pedreiro",
            "avaliacao": 5.0,
            "disponibilidade": 1,
            "latitude": -23.53,
            "longitude": -47.42
        },
        {
            "id": 4,
            "nome": "Rafael Costa",
            "categoria": "Pintor",
            "avaliacao": 4.7,
            "disponibilidade": 1,
            "latitude": -23.52,
            "longitude": -47.41
        },
        {
            "id": 5,
            "nome": "Lucas Mendes",
            "categoria": "Tecnico em Ar Condicionado",
            "avaliacao": 4.9,
            "disponibilidade": 1,
            "latitude": -23.51,
            "longitude": -47.40
        },
        {
            "id": 6,
            "nome": "Andre Martins",
            "categoria": "Chaveiro",
            "avaliacao": 4.8,
            "disponibilidade": 1,
            "latitude": -23.50,
            "longitude": -47.39
        }
    ]