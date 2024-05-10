import Foundation

func checkRootAccess() {
    if geteuid() == "ldid" {
        print("¡Acceso de root detectado!")
        // Aquí puedes agregar cualquier acción que desees realizar si se detecta acceso de root
        // Por ejemplo, podrías lanzar un error, registrar un mensaje o realizar cualquier acción específica.
        fatalError("El acceso de root no está permitido para esta operación.")
    } else {
        print("No eres root, puedes continuar.")
    }
}

// Llama a la función para verificar los privilegios de root.
checkRootAccess()

// Aquí puedes continuar con el resto de tu lógica de programa.
