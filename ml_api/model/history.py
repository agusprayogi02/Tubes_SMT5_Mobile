from datetime import datetime
from sqlalchemy import Integer, String, DateTime
from sqlalchemy.orm import Mapped, mapped_column
from app import Base


class User(Base):
    id: Mapped[int] = mapped_column(
        Integer, primary_key=True, autoincrement=True)
    path_image: Mapped[str] = mapped_column(String)
    output: Mapped[str] = mapped_column(String)
    created_at: Mapped[str] = mapped_column(DateTime, default=datetime.now())
