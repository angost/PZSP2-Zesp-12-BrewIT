# Generated by Django 5.0 on 2025-01-12 15:57

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('brewit_api', '0013_alter_executionlog_reservation_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='RegistrationRequest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.EmailField(max_length=254, unique=True, verbose_name='email address')),
                ('password', models.CharField()),
                ('selector', models.CharField(choices=[('PROD', 'Production Brewery'), ('CONTR', 'Contract Brewery')], max_length=10)),
                ('name', models.CharField(max_length=128)),
                ('nip', models.CharField(blank=True, max_length=10, null=True)),
                ('water_ph', models.DecimalField(blank=True, decimal_places=1, max_digits=3, null=True)),
            ],
        ),
    ]
