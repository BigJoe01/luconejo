_G.package.path=_G.package.path..[[;./?.lua;./?/?.lua]]

assert( require 'premake.quickstart' )

local OS = os.get()
local settings = {
	links = {
		linux = { 'lua' },
		windows = { 'lua5.1' },
		macosx = { 'lua' }
	}
}

local function platform_specifics()
	-- platform specific --
	configuration 'macosx'
		targetprefix ''
		targetextension '.so'
	configuration { '*' }
end

------------------------
make_solution 'luconejo'
------------------------

targetdir '.'

includedirs { 
	'./rabbitmq-c/librabbitmq',
	'./LuaBridge-1.0.2'
}

defines { 'BOOST_NO_VARIADIC_TEMPLATES' }

--------------------------
make_static_lib( 'rabbitmq',
	{
		'./rabbitmq-c/librabbitmq/*.h',
		'./rabbitmq-c/librabbitmq/*.c'
	}
)

excludes {
	'./rabbitmq-c/librabbitmq/amqp_cyassl.c',
	'./rabbitmq-c/librabbitmq/amqp_openssl.c',
	'./rabbitmq-c/librabbitmq/amqp_polarssl.c',
	'./rabbitmq-c/librabbitmq/amqp_gnutls.c'
}

language "C"

----------------------------
make_shared_lib( 'luconejo',
	{
		'./src/*.h',
		'./src/*.cpp'
	}
)
language "C++"

links { 'rabbitmq' , settings.links[OS] }

platform_specifics()

newaction {
   trigger     = "test",
   description = "run lua test",
   execute     = function ()
      os.execute("busted src/test.lua")
   end
}
