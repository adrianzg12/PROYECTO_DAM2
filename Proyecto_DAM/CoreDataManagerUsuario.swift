import CoreData
import Foundation

// Asegúrate de que este código esté dentro de Persistence.swift o en un archivo separado según tu estructura de proyecto.

struct CoreDataManagerUsuario {
    
    static let shared = CoreDataManagerUsuario()

    private let context = PersistenceController.shared.viewContext
    
    // Función para guardar un usuario
    func guardarUsuario(email: String, password: String, nombre: String) throws {
        let usuario = Usuario(context: context)
        usuario.id = UUID()
        usuario.email = email
        usuario.password = password
        usuario.nombre = nombre
        
        try context.save()
    }
    
    // Función para validar un usuario
    func validarUsuario(email: String, password: String) -> Usuario? {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        return (try? context.fetch(request))?.first
    }
    
    // Otras funciones relacionadas con el manejo de usuarios pueden ser agregadas aquí.
}
