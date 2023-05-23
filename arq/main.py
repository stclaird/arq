from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates

templates = Jinja2Templates(directory="templates")

application = FastAPI(
    title="Arq",
    description="Arq Simple Test"
)

arq = application

"""API Endpoint for the Home Page"""
@arq.get("/", response_class=HTMLResponse )
async def info(request: Request):
    with open('dynamicstring.txt', 'r') as file:
        dynamic_string = file.read().rstrip()

    return templates.TemplateResponse("homepage.html", {"request": request, "dynamicstring": dynamic_string})

"""Update the String endpoint - use this to update the string"""
@arq.get("/update/{dynamicstring}")
async def info(request: Request, dynamicstring: str ):
    with open('dynamicstring.txt', 'w') as f:
        f.write(dynamicstring)

    return {
        "response" : dynamicstring
    }