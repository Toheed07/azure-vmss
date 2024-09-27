import uvicorn
from fastapi import (
    FastAPI,
    Response,
    Query,
    Request,
    HTTPException,
    Depends,
    UploadFile,
    File,
    Form,
    BackgroundTasks,
    Body,
    Body,
)
from fastapi.encoders import jsonable_encoder
from fastapi.responses import StreamingResponse, JSONResponse, RedirectResponse
from starlette.middleware.cors import CORSMiddleware

app = FastAPI(title="PanduAI Backend", version="0.1.0")


@app.get("/")
def health_check():
    return {"message": "welcome here"}



@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/welcome")
def health_check():
    return {"status": "this is a test"}

app = CORSMiddleware(
    app=app,
    allow_origins=[
        "https://app.pandu.ai/",
        "https://app.pandu.ai",
        "http://localhost:3000",
        "http://localhost:3000/",
        "http://localhost:8000",
        "http://localhost:8000/",
        "https://app-new.pandu.ai",
        "https://app-new.pandu.ai/",
    ],
    allow_credentials=True,
    # allow_methods=["GET", "PUT", "POST", "DELETE", "OPTIONS", "PATCH"],
    # allow_headers=["Content-Type"] + get_all_cors_headers(),
    allow_methods=["*"],
    allow_headers=["*"],
)


if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8080, reload=True)
