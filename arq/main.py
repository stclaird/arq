from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates


templates = Jinja2Templates(directory="templates")

application = FastAPI(
    title="Arq",
    description="Arq Simple Test"
)

arq = application


# @arq.get("/", tags=["Home"], summary="Home")
# async def info():
#     return {
#         "string": "The saved string is dynamic string"
#     }

dynamic_string = "Test"


@arq.get("/", response_class=HTMLResponse )
async def info(request: Request):
    with open('dynamicstring.txt', 'r') as file:
        dynamic_string = file.read().rstrip()

    return templates.TemplateResponse("homepage.html", {"request": request, "dynamicstring": dynamic_string})


@arq.get("/update/{dynamicstring}")
async def info(request: Request, dynamicstring: str ):
    with open('dynamicstring.txt', 'w') as f:
        f.write(dynamicstring)
        
    # with open('dynamicstring.txt', 'r') as file:
    #     dynamic_string = file.read().rstrip()

    return {
        "response" : dynamicstring
    }