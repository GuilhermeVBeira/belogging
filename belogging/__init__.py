import logging

from .loader import BeloggingLoader


# Sugar

__loaded = False


def load(log_format=None, enable_duplication_filter=False, custom_handler=False, **options):
    loader = BeloggingLoader(**options)

    if custom_handler is not False:
        loader.add_custom_handler(custom_handler)

    if log_format is not None:
        loader.update_default_formatter(log_format)

    if enable_duplication_filter:
        loader.add_filter('logger_duplication',
                          'belogging.filters.LoggerDuplicationFilter')

    global __loaded
    retval = loader.setup()
    __loaded = True
    return retval


def getLogger(name):
    if __loaded:
        return logging.getLogger(name)

    load()
    return getLogger(name)
