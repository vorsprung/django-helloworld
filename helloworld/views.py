from django.http import HttpResponse

def index(request):
    return HttpResponse("🐱 🐱 🐱  Hello world! 🐱 🐱 🐱")
def dog(request):
    return HttpResponse("DOG DOG DOG")