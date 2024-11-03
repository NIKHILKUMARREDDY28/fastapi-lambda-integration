import os

from fastapi import FastAPI
from mangum import Mangum



app = FastAPI()

handler = Mangum(app)


@app.get("/")
def read_root():
    return {"Hello": "World"}


if __name__ == "__main__":
    PORT = int(os.environ.get("PORT", 8000))
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=PORT)