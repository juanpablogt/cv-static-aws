# CV estático en AWS S3

Este proyecto publica el CV como un sitio estático en un bucket S3 público mediante Terraform.

## Requisitos

- Terraform 1.6 o superior.
- Una cuenta AWS.
- Credenciales AWS configuradas localmente, por ejemplo con `aws configure` o variables de entorno.
- Un nombre de bucket único a nivel mundial.

## Despliegue

1. Copia el archivo de variables:

	```sh
	cp terraform.tfvars.example terraform.tfvars
	```

2. Edita `terraform.tfvars` y define un nombre único para el bucket.

3. Inicializa y valida Terraform:

	```sh
	terraform init
	terraform validate
	```

4. Revisa y aplica los cambios:

	```sh
	terraform plan
	terraform apply
	```

5. Obtén la URL pública:

	```sh
	terraform output -raw website_url
	```

El sitio se publica mediante el endpoint HTTP de Website Hosting de S3. El bucket queda deliberadamente público para que el CV sea visible desde Internet; la política solo permite leer objetos, no modificarlos.

## Actualizar el CV

Después de modificar `index.html`, `style.css` o `script.js`, ejecuta de nuevo:

```sh
terraform apply
```

Para una URL HTTPS y un dominio personalizado, el siguiente paso recomendado es añadir CloudFront delante del bucket.
