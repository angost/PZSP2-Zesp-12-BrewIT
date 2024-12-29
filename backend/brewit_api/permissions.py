from rest_framework import permissions
from .models import Account

class IsProductionBrewery(permissions.BasePermission):
    message = 'You must be a Production Brewery to access this endpoint.'
    def has_permission(self, request, view):
        return request.user.role == Account.AccountRoles.PRODUCTION.value