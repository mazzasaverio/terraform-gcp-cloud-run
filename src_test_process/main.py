import os
import json
from loguru import logger
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request

import sqlalchemy
from sqlalchemy import Column, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy import inspect

from connect_connector import connect_with_connector
from connect_connector_auto_iam_authn import connect_with_connector_auto_iam_authn
from connect_tcp import connect_tcp_socket
from connect_unix import connect_unix_socket

# Load environment variables
load_dotenv()

app = FastAPI()

# Database model
Base = declarative_base()


class PDF(Base):
    __tablename__ = "pdfs"
    pdf_key = Column(String, primary_key=True, index=True)
    elements = Column(Text)
    __table_args__ = {"extend_existing": True}


# Check if the table exists and create it if it doesn't
def create_tables(engine, Base):
    inspector = inspect(engine)
    if not inspector.has_table(PDF.__tablename__):
        logger.info(f"Creating table: {PDF.__tablename__}")
        Base.metadata.create_all(engine)
    else:
        logger.info(f"Table {PDF.__tablename__} already exists.")


def init_connection_pool() -> sqlalchemy.engine.base.Engine:
    if os.environ.get("INSTANCE_HOST"):
        return connect_tcp_socket()
    if os.environ.get("INSTANCE_UNIX_SOCKET"):
        return connect_unix_socket()
    if os.environ.get("INSTANCE_CONNECTION_NAME"):
        return (
            connect_with_connector_auto_iam_authn()
            if os.environ.get("DB_IAM_USER")
            else connect_with_connector()
        )
    raise ValueError(
        "Missing database connection type. Please define one of INSTANCE_HOST, INSTANCE_UNIX_SOCKET, or INSTANCE_CONNECTION_NAME"
    )


# Database connection setup
engine = init_connection_pool()
SessionLocal = scoped_session(
    sessionmaker(autocommit=False, autoflush=False, bind=engine)
)

# Create tables if they don't exist
create_tables(engine, Base)


# Function to process PDFs
def process_pdf(bucket_name: str, pdf_key: str, SessionLocal, PDFModel):
    logger.info(f"Processing PDF: {pdf_key}")
    try:
        # Placeholder for actual PDF processing
        elements_json = {"example": "data"}

        # Database operation
        with SessionLocal() as db:
            existing_pdf = (
                db.query(PDFModel).filter(PDFModel.pdf_key == pdf_key).first()
            )
            if existing_pdf:
                logger.info(f"PDF data already in database: {pdf_key}")
            else:
                db_pdf = PDFModel(pdf_key=pdf_key, elements=json.dumps(elements_json))
                db.add(db_pdf)
                db.commit()
                logger.info(f"PDF data inserted into the database: {pdf_key}")
    except Exception as e:
        logger.exception("Error processing PDF.")
        raise HTTPException(status_code=500, detail=str(e))
    return {"status": "Processed"}


# API Endpoints
@app.post("/")
async def api_process_pdf(request: Request):
    pdf_key = "aaaaaaa.pdf"
    return process_pdf("bucket-gcp-v1", pdf_key, SessionLocal, PDF)


@app.get("/")
async def read_root():
    return {"Hello": "World"}


# Main execution
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="127.0.0.1", port=8080)
