from __future__ import unicode_literals
from django.utils.translation import ugettext_lazy as _
from django.core.exceptions import ValidationError
from django.db import models
from django.contrib.auth.models import User

def validate_domain(domain):
    """
        Check is the domain name is well formated
        Chek on RegexValidator
        https://docs.djangoproject.com/fr/1.10/ref/validators/#regexvalidator
    """

class Domain(models.Model):
    """
        Domain management
        Postfix virtual domains
    """
    administrator = models.ManyToManyField(User)
    name = models.CharField(_('Domain name'), max_length=255, unique=True, validators=[validate_domain])
    active = models.BooleanField(_('Domain is active ?'), default=True)


class Mailboxe(models.Model):
    """
        Mailbox management
        Postfix virtual mailboxes
    """
    def __unicode__(self):
        return self.email

    administrator = models.ManyToManyField(User)
    email = models.EmailField(_('Email address'), unique=True)
    password = models.CharField(_('Password'), max_length=255)
    domain = models.ForeignKey(Domain, on_delete=models.CASCADE)
    active = models.BooleanField(_('Mailbox is active ?'), default=True)
    quota = models.PositiveIntegerField(_('Mailbox quota (Kb)'))

class Aliase(models.Model):
    """
        Aliases management
        Postfix virtual aliases
    """
    administrator = models.ManyToManyField(User)
    domain = models.ForeignKey(Domain, on_delete=models.CASCADE)
    source = models.EmailField(_('From'), unique=True),
    destination = models.EmailField(_('To')),
