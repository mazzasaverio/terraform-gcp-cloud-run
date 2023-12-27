# Standard and third-party library imports
import os
import json
from loguru import logger
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Request
from sqlalchemy import Column, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, scoped_session, Session

# Local module imports


import sqlalchemy
import logging

from connect_connector import connect_with_connector
from connect_connector_auto_iam_authn import connect_with_connector_auto_iam_authn
from connect_tcp import connect_tcp_socket
from connect_unix import connect_unix_socket
from sqlalchemy import inspect

app = FastAPI()

logger = logging.getLogger()

# Load environment variables
load_dotenv()

# Database model
Base = declarative_base()


class PDF(Base):
    __tablename__ = "pdfs"
    pdf_key = Column(String, primary_key=True, index=True)
    elements = Column(Text)
    __table_args__ = {"extend_existing": True}  # Add this line


# Check if the table exists and create it if it doesn't
# Function to create tables
def create_tables(engine, Base):
    inspector = inspect(engine)
    if not inspector.has_table(PDF.__tablename__):
        logger.info(f"Creating table: {PDF.__tablename__}")
        Base.metadata.create_all(engine)
    else:
        logger.info(f"Table {PDF.__tablename__} already exists.")


def init_connection_pool() -> sqlalchemy.engine.base.Engine:
    """Sets up connection pool for the app."""
    # use a TCP socket when INSTANCE_HOST (e.g. 127.0.0.1) is defined
    if os.environ.get("INSTANCE_HOST"):
        return connect_tcp_socket()

    # use a Unix socket when INSTANCE_UNIX_SOCKET (e.g. /cloudsql/project:region:instance) is defined
    if os.environ.get("INSTANCE_UNIX_SOCKET"):
        return connect_unix_socket()

    # use the connector when INSTANCE_CONNECTION_NAME (e.g. project:region:instance) is defined
    if os.environ.get("INSTANCE_CONNECTION_NAME"):
        # Either a DB_USER or a DB_IAM_USER should be defined. If both are
        # defined, DB_IAM_USER takes precedence.
        return (
            connect_with_connector_auto_iam_authn()
            if os.environ.get("DB_IAM_USER")
            else connect_with_connector()
        )

    raise ValueError(
        "Missing database connection type. Please define one of INSTANCE_HOST, INSTANCE_UNIX_SOCKET, or INSTANCE_CONNECTION_NAME"
    )


# Load environment variables
load_dotenv()


# Database connection setup
engine = init_connection_pool()
SessionLocal = scoped_session(
    sessionmaker(autocommit=False, autoflush=False, bind=engine)
)

# Create tables if they don't exist
create_tables(engine, Base)

# Function to process PDFs


def process_pdf(bucket_name: str, pdf_key: str, SessionLocal, PDFModel):
    """
    Process a PDF file and update the database.

    :param bucket_name: Name of the bucket where the PDF is stored.
    :param pdf_key: Key of the PDF file in the bucket.
    :param SessionLocal: Database session maker.
    :param PDFModel: The PDF model class.
    :return: Status dictionary.
    """
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
                # Record already exists, log a message
                logger.info(f"PDF data already in database: {pdf_key}")
            else:
                # Record does not exist, insert it
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
    return await process_pdf("bucket-gcp-v1", pdf_key, SessionLocal, PDF)


@app.get("/")
async def read_root():
    return {"Hello": "World"}


# Main execution
if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="127.0.0.1", port=8080)
