from django.shortcuts import render
from rest_framework import generics
from .serializers import ThreatSerializer, VulnSerializer
from .models import Threats, Vulnerabilities
from django.contrib.auth.decorators import login_required
# Create your views here.


class ThreatView(generics.ListAPIView):
    queryset = Threats.objects.all()
    serializer_class =  ThreatSerializer

class VulnView(generics.ListAPIView):
    queryset = Vulnerabilities.objects.all()
    serializer_class = VulnSerializer
     
