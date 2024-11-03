from fastapi import FastAPI
from mangum import Mangum



app = FastAPI()

handler = Mangum(app)


@app.get("/")
def read_root():
    return {"Hello": "World"}


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app)