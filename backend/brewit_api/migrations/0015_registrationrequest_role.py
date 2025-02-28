# Generated by Django 5.0 on 2025-01-12 16:20

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('brewit_api', '0014_registrationrequest'),
    ]

    operations = [
        migrations.AddField(
            model_name='registrationrequest',
            name='role',
            field=models.CharField(choices=[('PROD', 'Production Brewery'), ('CONTR', 'Contract Brewery'), ('ADMIN', 'Administrator')], default='PROD', max_length=5),
            preserve_default=False,
        ),
    ]
