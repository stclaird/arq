"""API to provide simple Dynamic String API"""
from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")

application = FastAPI(
    title="Arq",
    description="Arq Simple Test"
)

arq = application


@arq.get("/", response_class=HTMLResponse )
async def info(request: Request):
    """API Endpoint for the Home Page"""

    with open('dynamicstring.txt', 'r', encoding="utf-8") as file:
        dynamic_string = file.read().rstrip()

    return templates.TemplateResponse("homepage.html",
                                      {"request": request, "dynamicstring": dynamic_string}
                                    )


@arq.get("/update/{dynamicstring}")
async def update(request: Request, dynamicstring: str ):
    """API Endpoint to update dynamic string"""
    with open('dynamicstring.txt', 'w', encoding="utf-8") as dynamic_file:
        dynamic_file.write(dynamicstring)

    return {
        "response" : dynamicstring
    }
