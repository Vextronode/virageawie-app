<?php

arch('domain code does not depend on the HTTP layer')
    ->expect('App\Domain')
    ->not->toUse('Illuminate\Http');

arch('controllers do not query the database directly')
    ->expect('App\Http\Controllers')
    ->not->toUse('Illuminate\Support\Facades\DB');

arch()->preset()->php();

arch()->preset()->security();

arch()->preset()->laravel();
