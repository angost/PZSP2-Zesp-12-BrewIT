from django.contrib.auth import get_user_model
from rest_framework.views import APIView
from rest_framework import generics
from rest_framework.response import Response
from django.http import Http404
from brewit_api.serializers import AccountSerializer, RegistrationRequestSerializer, EquipmentSerializer,\
     SectorSerializer, BrewerySerializer, EquipmentFilterParametersSerializer, BreweriesFilterParametersSerializer,\
     ReservationRequestCreateSerializer, ReservationCreateSerializer, ReservationSerializer, RecipeSerializer,\
     ExecutionLogSerializer, ExecutionLogEditSerializer, BeerTypeSerializer, CleanupSerializer,\
     EquipmentReservationSerializer, SectorEditSerializer, EquipmentEditSerializer, BreweryStatisticsSerializer,\
     CombinedStatisticsSerializer, BreweryCreateSerializer, BreweryWithAccountSerializer, WorkerSerializer,\
     ReservationRequestSerializer, EquipmentWithReservationsSerializer, BreweryEditSerializer
from rest_framework.reverse import reverse
from rest_framework.decorators import api_view
from django.contrib.auth import authenticate, login, logout
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .permissions import IsProductionBrewery, IsBrewery, IsContractBrewery, IsAdmin
from .models import Equipment, Sector, Brewery, ReservationRequest, EquipmentReservation, Reservation,\
                    EqipmentReservationRequest, Recipe, ExecutionLog, BeerType, RegistrationRequest,\
                    Worker
# from .auth_class import CsrfExemptSessionAuthentication
from rest_framework.authentication import BasicAuthentication, SessionAuthentication
from .filters import BreweryFilter, EquipmentFilter, EquipmentReservationFilter
from django_filters import rest_framework as filters
from .utils import filter_equipment, filter_breweries, get_brewery_statistics, get_combined_statistics
from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import serializers


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
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAdmin]

    def get(self, request, format=None):
        users = get_user_model().objects.all()
        serializer = AccountSerializer(users, many=True, context={'request': request})
        return Response(serializer.data)


class AccountDetail(APIView):
    serializer_class = AccountSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAdmin]

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
    authentication_classes = [SessionAuthentication, BasicAuthentication]

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


class RegistrationRequestList(APIView):
    serializer_class = RegistrationRequestSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = []

    def get_permissions(self):
        self.permission_classes = []
        if self.request.method == "GET":
            self.permission_classes = [IsAuthenticated, IsAdmin]
        return super(RegistrationRequestList, self).get_permissions()

    def post(self, request, format=None):
        serializer = RegistrationRequestSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, format=None):
        requests = RegistrationRequest.objects.all()
        serializer = RegistrationRequestSerializer(requests, many=True, context={'request': request})
        return Response(serializer.data)


class RegistrationRequestDetail(APIView):
    serializer_class = RegistrationRequestSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsAdmin]

    def get_object(self, pk):
        try:
            return RegistrationRequest.objects.get(pk=pk)
        except RegistrationRequest.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        request = self.get_object(pk)
        serializer = RegistrationRequestSerializer(request, context={'request': request})
        return Response(serializer.data)

    def delete(self, request, pk, format=None):
        request = self.get_object(pk)
        request.delete()
        return Response({'detail':'Registration request deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class RegistrationRequestAccept(APIView):
    serializer_class = BreweryCreateSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsAdmin]

    @extend_schema(
        request=BreweryCreateSerializer,
        responses={
            201: OpenApiResponse(
                response=BreweryWithAccountSerializer(),
                description="Registration request accepted successfully"
            ),
            400: OpenApiResponse(
                response=None,
                description="Invalid input parameters"
            )
        }
    )
    def post(self, request, format=None):
        serializer = BreweryCreateSerializer(data=request.data)
        if serializer.is_valid():
            brewery = serializer.save()
            brewery_serializer = BreweryWithAccountSerializer(brewery)
            return Response(brewery_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MyBreweryDetail(APIView):
    serializer_class = BreweryWithAccountSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsBrewery]

    def get(self, request, format=None):
        brewery = request.user.get_brewery()
        serializer = BreweryWithAccountSerializer(brewery, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=BreweryEditSerializer,
        responses=BreweryEditSerializer,
    )
    def put(self, request, format=None):
        brewery = request.user.get_brewery()
        serializer = BreweryEditSerializer(brewery, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class Logout(APIView):
    authentication_classes = [SessionAuthentication, BasicAuthentication]

    def post(self, request, format=None):
        logout(request)
        return Response({'detail':'Logged out successfully.'}, status=status.HTTP_200_OK)


class SectorList(APIView):
    serializer_class = SectorSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    def get(self, request, format=None):
        sectors = Sector.objects.filter(brewery=request.user.get_brewery()).all()
        serializer = SectorSerializer(sectors, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = SectorSerializer(data=request.data)
        if serializer.is_valid():
            brewery = request.user.get_brewery()
            serializer.save(brewery=brewery)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SectorDetail(APIView):
    serializer_class = SectorSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
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

    @extend_schema(
        request=SectorEditSerializer,
        responses=SectorEditSerializer,
    )
    def put(self, request, pk, format=None):
        sector = self.get_object(pk)
        serializer = SectorEditSerializer(sector, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        sector = self.get_object(pk)
        if Equipment.objects.filter(sector=sector).exists():
            return Response({'detail':'Cannot delete sector with equipment assigned.'}, status=status.HTTP_400_BAD_REQUEST)
        sector.delete()
        return Response({'detail':'Sector deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class EquipmentList(generics.ListCreateAPIView):
    serializer_class = EquipmentSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
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
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated]
    def get_object(self, pk, request):
        try:
            return Equipment.objects.get(pk=pk)
        except Equipment.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        equipment = self.get_object(pk, request)
        serializer = EquipmentSerializer(equipment, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=EquipmentEditSerializer,
        responses=EquipmentEditSerializer,
    )
    def put(self, request, pk, format=None):
        equipment = self.get_object(pk, request)
        serializer = EquipmentEditSerializer(equipment, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        equipment = self.get_object(pk, request)
        if EquipmentReservation.objects.filter(equipment=equipment).exists():
            return Response({'detail':'Cannot delete equipment with active reservations.'}, status=status.HTTP_400_BAD_REQUEST)
        if EqipmentReservationRequest.objects.filter(equipment=equipment).exists():
            return Response({'detail':'Cannot delete equipment with active reservation requests.'}, status=status.HTTP_400_BAD_REQUEST)
        equipment.delete()
        return Response({'detail':'Equipment deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class EquipmentFiltered(APIView):
    serializer_class = EquipmentFilterParametersSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    @extend_schema(
        request=EquipmentFilterParametersSerializer,
        responses={
            200: OpenApiResponse(
                response=EquipmentWithReservationsSerializer(many=True),
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
            serializer = EquipmentWithReservationsSerializer(equipment, many=True, context={'request': request})
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BreweryFiltered(APIView):
    serializer_class = BreweriesFilterParametersSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
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
    authentication_classes = [SessionAuthentication, BasicAuthentication]
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
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated]
    def get_object(self, pk):
        breweries = Brewery.objects.all()
        try:
            return breweries.get(pk=pk)
        except Brewery.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        brewery = self.get_object(pk)
        serializer = BrewerySerializer(brewery, context={'request': request})
        return Response(serializer.data)


class ReservationRequestList(APIView):
    serializer_class = ReservationRequestCreateSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsBrewery]

    @extend_schema(
        responses=ReservationRequestSerializer
    )
    def get(self, request, format=None):
        if request.user.role == get_user_model().AccountRoles.PRODUCTION.value:
            reservations = ReservationRequest.objects.filter(production_brewery=request.user.get_brewery())
        else:
            reservations = ReservationRequest.objects.filter(contract_brewery=request.user.get_brewery())
        serializer = ReservationRequestSerializer(reservations, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = ReservationRequestCreateSerializer(data=request.data,
                                                  context={'request': request,
                                                           'contract_brewery': request.user.get_brewery()})
        if serializer.is_valid():
            serializer.save(contract_brewery=request.user.get_brewery())
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get_permissions(self):
        self.permission_classes = [IsAuthenticated, IsBrewery]
        if self.request.method == "POST":
            self.permission_classes = [IsAuthenticated, IsContractBrewery]
        return super(ReservationRequestList, self).get_permissions()


class ReservationRequestDetail(APIView):
    serializer_class = ReservationRequestSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsBrewery]

    def get_object(self, pk):
        try:
            if self.request.user.role == get_user_model().AccountRoles.PRODUCTION.value:
                return ReservationRequest.objects.get(production_brewery=self.request.user.get_brewery(), pk=pk)
            else:
                return ReservationRequest.objects.get(contract_brewery=self.request.user.get_brewery(), pk=pk)
        except ReservationRequest.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        reservation = self.get_object(pk)
        serializer = ReservationRequestSerializer(reservation, context={'request': request})
        return Response(serializer.data)

    def delete(self, request, pk, format=None):
        reservation = self.get_object(pk)
        reservation.delete()
        return Response({'detail':'Reservation request deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class ReservationList(APIView):
    authentication_classes = [SessionAuthentication, BasicAuthentication]

    def get_permissions(self):
        self.permission_classes = [IsAuthenticated, IsBrewery]
        if self.request.method == "POST":
            self.permission_classes = [IsAuthenticated, IsProductionBrewery]
        return super(ReservationList, self).get_permissions()

    @extend_schema(
        request=ReservationCreateSerializer,
        responses={
            201: OpenApiResponse(
                response=ReservationSerializer(many=False),
                description="New reservation created successfully"
            ),
            400: OpenApiResponse(
                response=None,
                description="Invalid input"
            )
        }
    )
    def post(self, request):
        serializer = ReservationCreateSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            try:
                reservation = serializer.save()
            except serializers.ValidationError as e:
                return Response({'detail':str(e)}, status=status.HTTP_400_BAD_REQUEST)
            output_data = ReservationSerializer(reservation, context={'request': request}).data
            return Response(output_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        responses={
            200: OpenApiResponse(
                response=ReservationSerializer(many=False),
                description="Reservation returned successfully"
            ),
            400: OpenApiResponse(
                response=None,
                description="Reservation not found"
            )
        }
    )
    def get(self, request):
        if request.user.role == get_user_model().AccountRoles.PRODUCTION.value:
            reservations = Reservation.objects.filter(production_brewery=request.user.get_brewery())
        else:
            reservations = Reservation.objects.filter(contract_brewery=request.user.get_brewery())
        serializer = ReservationSerializer(reservations, many=True, context={'request': request})
        return Response(serializer.data)


class ReservationDetail(APIView):
    serializer_class = ReservationSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsBrewery]

    def get_object(self, pk):
        try:
            if self.request.user.role == get_user_model().AccountRoles.PRODUCTION.value:
                return Reservation.objects.get(production_brewery=self.request.user.get_brewery(), pk=pk)
            else:
                return Reservation.objects.get(contract_brewery=self.request.user.get_brewery(), pk=pk)
        except Reservation.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        reservation = self.get_object(pk)
        serializer = ReservationSerializer(reservation, context={'request': request})
        return Response(serializer.data)

    def delete(self, request, pk, format=None):
        reservation = self.get_object(pk)
        reservation.delete()
        return Response({'detail':'Reservation deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class RecipeDetail(APIView):
    serializer_class = RecipeSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    def get_object(self, pk):
        try:
            return Recipe.objects.get(contract_brewery=self.request.user.get_brewery(), pk=pk)
        except Recipe.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        recipe = self.get_object(pk)
        serializer = RecipeSerializer(recipe, context={'request': request})
        return Response(serializer.data)

    def delete(self, request, pk, format=None):
        recipe = self.get_object(pk)
        if ExecutionLog.objects.filter(recipe=recipe).exists():
            return Response({'detail':'Cannot delete recipe used in execution log.'}, status=status.HTTP_400_BAD_REQUEST)
        recipe.delete()
        return Response({'detail':'Recipe deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class RecipeList(generics.ListCreateAPIView):
    serializer_class = RecipeSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    def get_queryset(self):
        return Recipe.objects.filter(contract_brewery=self.request.user.get_brewery())

    def perform_create(self, serializer):
        serializer.save(contract_brewery=self.request.user.get_brewery())


class ExecutionLogList(APIView):
    serializer_class = ExecutionLogSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    def get(self, request, format=None):
        logs = ExecutionLog.objects.filter(reservation__contract_brewery=request.user.get_brewery())
        serializer = ExecutionLogSerializer(logs, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request, format=None):
        serializer = ExecutionLogSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ExecutionLogDetail(APIView):
    serializer_class = ExecutionLogSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    def get_object(self, pk):
        try:
            return ExecutionLog.objects.get(reservation__contract_brewery=self.request.user.get_brewery(), pk=pk)
        except ExecutionLog.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        log = self.get_object(pk)
        serializer = ExecutionLogSerializer(log, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=ExecutionLogEditSerializer,
        responses=ExecutionLogEditSerializer,
    )
    def put(self, request, pk, format=None):
        log = self.get_object(pk)
        serializer = ExecutionLogEditSerializer(log, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BeerTypeList(generics.ListAPIView):
    serializer_class = BeerTypeSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return BeerType.objects.all()


class BeerTypeDetail(generics.RetrieveAPIView):
    serializer_class = BeerTypeSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated]
    queryset = BeerType.objects.all()


class CleanupCreate(APIView):
    serializer_class = CleanupSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]

    def post(self, request):
        serializer = CleanupSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save(selector=EquipmentReservation.EquipmentSelectors.CLEAN.value)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CleanupDelete(APIView):
    serializer_class = CleanupSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]

    def delete(self, request, pk):
        try:
            cleanup = EquipmentReservation.objects.get(equipment__brewery=request.user.get_brewery(),
                                                       selector=EquipmentReservation.EquipmentSelectors.CLEAN.value,
                                                       pk=pk)
        except EquipmentReservation.DoesNotExist:
            raise Http404
        cleanup.delete()
        return Response({'detail':'Cleanup deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)


class EquipmentReservationList(generics.ListAPIView):
    serializer_class = EquipmentReservationSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsProductionBrewery]
    filter_backends = (filters.DjangoFilterBackend,)
    filterset_class = EquipmentReservationFilter

    def get_queryset(self):
        return EquipmentReservation.objects.filter(
            equipment__brewery=self.request.user.get_brewery(),
        )


class StatisticsList(APIView):
    serializer_class = BreweryStatisticsSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsAdmin]

    def get(self, request):
        stats = get_brewery_statistics()
        serializer = BreweryStatisticsSerializer(stats, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class CombinedStatisticsList(APIView):
    serializer_class = CombinedStatisticsSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsAdmin]

    def get(self, request):
        stats = get_combined_statistics()
        serializer = CombinedStatisticsSerializer(stats, many=False)
        return Response(serializer.data, status=status.HTTP_200_OK)


class WorkerList(APIView):
    serializer_class = WorkerSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    def get(self, request):
        workers = Worker.objects.filter(brewery=request.user.get_brewery())
        serializer = WorkerSerializer(workers, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = WorkerSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class WorkerDetail(APIView):
    serializer_class = WorkerSerializer
    authentication_classes = [SessionAuthentication, BasicAuthentication]
    permission_classes = [IsAuthenticated, IsContractBrewery]

    def get_object(self, pk):
        try:
            return Worker.objects.get(brewery=self.request.user.get_brewery(), pk=pk)
        except Worker.DoesNotExist:
            raise Http404

    def get(self, request, pk):
        worker = self.get_object(pk)
        serializer = WorkerSerializer(worker)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def put(self, request, pk):
        worker = self.get_object(pk)
        serializer = WorkerSerializer(worker, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        worker = self.get_object(pk)
        worker.delete()
        return Response({'detail':'Worker deleted successfully.'}, status=status.HTTP_204_NO_CONTENT)