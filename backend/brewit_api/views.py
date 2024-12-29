from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework.response import Response
from django.http import Http404
from brewit_api.serializers import AccountSerializer, RegistrationDataSerializer, EquipmentSerializer,\
     SectorSerializer
from rest_framework.reverse import reverse
from rest_framework.decorators import api_view
from django.contrib.auth import authenticate, login, logout
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .permissions import IsProductionBrewery
from .models import Equipment, Sector
from .auth_class import CsrfExemptSessionAuthentication
from rest_framework.authentication import BasicAuthentication


# for development purposes
@api_view(['GET'])
def api_root(request, format=None):
    return Response({
        'users': reverse('brewit_api:user-list', request=request, format=format),
        'sectors': reverse('brewit_api:sector-list', request=request, format=format),
        'equipment': reverse('brewit_api:equipment-list', request=request, format=format),
    })


class AccountList(APIView):
    serializer_class = AccountSerializer

    def get(self, request, format=None):
        users = get_user_model().objects.all()
        serializer = AccountSerializer(users, many=True, context={'request': request})
        return Response(serializer.data)


class AccountDetail(APIView):
    serializer_class = AccountSerializer

    def get_object(self, pk):
        try:
            return get_user_model().objects.get(pk=pk)
        except get_user_model().DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        user = self.get_object(pk)
        serializer = AccountSerializer(user, context={'request': request})
        return Response(serializer.data)


class Login(APIView):
    authentication_classes = []

    def post(self, request, format=None):
        email = request.data.get('email')
        password = request.data.get('password')

        user = authenticate(request=request, email=email, password=password)
        if user is not None:
            login(request, user)
            return Response({'detail':'Logged in successfully.',
                             'user_role': user.role},
                            status=status.HTTP_200_OK)
        else:
            return Response({'detail': 'Email or Password is incorrect.'}, status=status.HTTP_400_BAD_REQUEST)


class Register(APIView):
    serializer_class = RegistrationDataSerializer
    authentication_classes = []

    def post(self, request, format=None):
        serializer = RegistrationDataSerializer(data=request.data)
        if serializer.is_valid():
            try:
                account, brewery = serializer.save()
            except Exception as e:
                return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST) # Change later detail message
            return Response({'detail':'Registered successfully.'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class Logout(APIView):
    def post(self, request, format=None):
        logout(request)
        return Response({'detail':'Logged out successfully.'}, status=status.HTTP_200_OK)


class SectorList(APIView):
    serializer_class = SectorSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get(self, request, format=None):
        sectors = Sector.objects.all() # It's bad solution, need to change model so sector is connected to brewery
        serializer = SectorSerializer(sectors, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = SectorSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({'detail':'Sector added successfully.'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SectorDetail(APIView):
    serializer_class = SectorSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get_object(self, pk):
        try:
            return Sector.objects.get(pk=pk)
        except Sector.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        sector = self.get_object(pk)
        serializer = SectorSerializer(sector, context={'request': request})
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        sector = self.get_object(pk)
        serializer = SectorSerializer(sector, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        sector = self.get_object(pk)
        sector.delete()
        return Response({'detail':'Sector deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class EquipmentList(APIView):
    serializer_class = EquipmentSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get(self, request, format=None):
        equipment = Equipment.objects.filter(brewery__in=request.user.breweries.all())
        serializer = EquipmentSerializer(equipment, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request, format=None):
        brewery = request.user.get_brewery()
        serializer = EquipmentSerializer(data=request.data, context={'brewery':brewery})
        if serializer.is_valid():
            serializer.save()
            return Response({'detail':'Equipment added successfully.'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class EquipmentDetail(APIView):
    serializer_class = EquipmentSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get_object(self, pk, request):
        try:
            return Equipment.objects.filter(brewery__in=request.user.breweries.all()).get(pk=pk)
        except Equipment.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        equipment = self.get_object(pk, request)
        serializer = EquipmentSerializer(equipment, context={'request': request})
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        equipment = self.get_object(pk, request)
        serializer = EquipmentSerializer(equipment, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        equipment = self.get_object(pk, request)
        equipment.delete()
        return Response({'detail':'Equipment deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


