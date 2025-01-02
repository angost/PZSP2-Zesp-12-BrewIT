from rest_framework import permissions
from .models import Account

class IsProductionBrewery(permissions.BasePermission):
    message = 'You must be a Production Brewery to access this endpoint.'
    def has_permission(self, request, view):
        return request.user.role == Account.AccountRoles.PRODUCTION.value

class IsContractBrewery(permissions.BasePermission):
    message = 'You must be a Contract Brewery to access this endpoint.'
    def has_permission(self, request, view):
        return request.user.role == Account.AccountRoles.CONTRACT.value

class IsBrewery(permissions.BasePermission):
    message = 'You must be a Brewery to access this endpoint.'
    def has_permission(self, request, view):
        return request.user.role == Account.AccountRoles.PRODUCTION.value\
               or request.user.role == Account.AccountRoles.CONTRACT.value