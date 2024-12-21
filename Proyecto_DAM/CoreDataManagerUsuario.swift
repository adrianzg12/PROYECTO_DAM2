import CoreData
import Foundation


struct CoreDataManagerUsuario {
    
    static let shared = CoreDataManagerUsuario()

    private let context = PersistenceController.shared.viewContext
    
    func guardarUsuario(email: String, password: String, nombre: String) throws {
        let usuario = Usuario(context: context)
        usuario.id = UUID()
        usuario.email = email
        usuario.password = password
        usuario.nombre = nombre
        
        try context.save()
    }
    
    func validarUsuario(email: String, password: String) -> Usuario? {
        let request: NSFetchRequest<Usuario> = Usuario.fetchRequest()
        request.predicate = NSPredicate(format: "email == %@ AND password == %@", email, password)
        
        return (try? context.fetch(request))?.first
    }
    
}
