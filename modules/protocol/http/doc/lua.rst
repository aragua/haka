
.. highlightlang:: lua

HTTP
====

.. lua:module:: http


Dissector
---------

.. lua:class:: http

    Dissector data for HTTP. In addition to the usuall `http-up` and  `http-down`, HTTP register two additional
    hooks:

    * `http-request`: called when a request is fully parsed.
    * `http-response`: called when a response is fully parsed.

    .. seealso:: :lua:class:`haka.dissector_data`.

    .. lua:data:: request

        .. lua:data:: method
                      uri
                      version

            Request line elements.

        .. lua:data:: headers

            Headers table.

        .. lua:data:: data

            Stream of HTTP data.

    .. lua:data:: response

        .. lua:data:: version
                      status
                      reason

            Response line elements.

        .. lua:data:: headers

            Headers table.

        .. lua:data:: data

            Stream of HTTP data.

Example
-------

.. literalinclude:: ../../../../sample/standard/proto/http/policy.lua
    :language: lua