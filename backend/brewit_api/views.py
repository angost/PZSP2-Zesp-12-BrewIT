from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from django.http import Http404
from brewit_api.serializers import AccountSerializer, RegistrationDataSerializer, EquipmentSerializer,\
     SectorSerializer, BrewerySerializer, EquipmentFilterParametersSerializer, BreweriesFilterParametersSerializer
from rest_framework.reverse import reverse
from rest_framework.decorators import api_view
from django.contrib.auth import authenticate, login, logout
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .permissions import IsProductionBrewery, IsBrewery, IsContractBrewery
from .models import Equipment, Sector, Brewery
from .auth_class import CsrfExemptSessionAuthentication
from rest_framework.authentication import BasicAuthentication
from .filters import BreweryFilter, EquipmentFilter
from django_filters import rest_framework as filters
from .utils import filter_equipment, filter_breweries
from drf_spectacular.utils import extend_schema, OpenApiResponse


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
            brewery = request.user.get_brewery()
            serializer.save(brewery=brewery)
            return Response({'detail':'Sector added successfully.'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SectorDetail(APIView):
    serializer_class = SectorSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get_object(self, pk):
        try:
            return self.request.user.get_brewery().sectors.get(pk=pk)
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


class EquipmentList(generics.ListCreateAPIView):
    serializer_class = EquipmentSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsBrewery]
    filter_backends = (filters.DjangoFilterBackend,)
    filterset_class = EquipmentFilter

    def get_permissions(self):
        self.permission_classes = [IsAuthenticated, IsBrewery]
        if self.request.method == "POST":
            self.permission_classes = [IsAuthenticated, IsProductionBrewery]
        return super(EquipmentList, self).get_permissions()

    def get_queryset(self):
        if self.request.user.role == get_user_model().AccountRoles.PRODUCTION.value:
            return Equipment.objects.filter(brewery=self.request.user.get_brewery())
        return Equipment.objects.all()

    def perform_create(self, serializer):
        serializer.save(brewery=self.request.user.get_brewery())


class EquipmentDetail(APIView):
    serializer_class = EquipmentSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get_object(self, pk, request):
        try:
            return request.user.get_brewery().equipment.get(pk=pk)
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


class EquipmentFiltered(APIView):
    serializer_class = EquipmentFilterParametersSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]

    @extend_schema(
        request=EquipmentFilterParametersSerializer,
        responses={
            200: OpenApiResponse(
                response=EquipmentSerializer(many=True),
                description="List of filtered equipment"
            ),
            400: OpenApiResponse(
                response=None,
                description="Invalid input parameters"
            )
        }
    )
    def post(self, request, format=None):
        serializer = EquipmentFilterParametersSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            data['contract_brewery'] = request.user.get_brewery().brewery_id
            equipment = filter_equipment(data)
            serializer = EquipmentSerializer(equipment, many=True, context={'request': request})
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BreweryFiltered(APIView):
    serializer_class = BreweriesFilterParametersSerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    @extend_schema(
        request=BreweriesFilterParametersSerializer,
        responses={
            200: OpenApiResponse(
                response=BrewerySerializer(many=True),
                description="List of filtered equipment"
            ),
            400: OpenApiResponse(
                response=None,
                description="Invalid input parameters"
            )
        }
    )
    def post(self, request, format=None):
        serializer = BreweriesFilterParametersSerializer(data=request.data)
        if serializer.is_valid():
            data = serializer.validated_data
            data['contract_brewery'] = request.user.get_brewery().brewery_id
            breweries = filter_breweries(data)
            serializer = BrewerySerializer(breweries, many=True, context={'request': request})
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BreweryList(generics.ListAPIView):
    serializer_class = BrewerySerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated]
    filter_backends = (filters.DjangoFilterBackend,)
    filterset_class = BreweryFilter

    def get_queryset(self):
        if self.request.user.role == get_user_model().AccountRoles.ADMIN.value:
            return Brewery.objects.all()
        elif self.request.user.role == get_user_model().AccountRoles.CONTRACT.value:
            return Brewery.objects.filter(selector=Brewery.BrewerySelectors.PRODUCTION.value)
        else:
            return Brewery.objects.filter(selector=Brewery.BrewerySelectors.CONTRACT.value)


class BreweryDetail(APIView):
    serializer_class = BrewerySerializer
    authentication_classes = [CsrfExemptSessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated]
    def get_object(self, pk):
        if self.request.user.role == get_user_model().AccountRoles.ADMIN.value:
            breweries = Brewery.objects.all()
        elif self.request.user.role == get_user_model().AccountRoles.CONTRACT.value:
            breweries = Brewery.objects.filter(selector=Brewery.BrewerySelectors.PRODUCTION.value)
        else:
            breweries = Brewery.objects.filter(selector=Brewery.BrewerySelectors.CONTRACT.value)
        try:
            return breweries.get(pk=pk)
        except Brewery.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        brewery = self.get_object(pk)
        serializer = BrewerySerializer(brewery, context={'request': request})
        return Response(serializer.data)
