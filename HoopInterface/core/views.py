from django.shortcuts import render


def homepage(request):
    """

    """
    context = {
        'title': "Bienvenue sur Hoop"
    }
    return render(request, 'core/homepage.html', context)
