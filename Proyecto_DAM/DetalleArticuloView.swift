import SwiftUI

struct DetalleArticuloView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var articulo: Articulo  // Artículo que se pasa a la vista
    @State private var showEditView = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        Form {
            // Sección de detalles del artículo
            Section(header: Text("Detalles del Artículo")) {
                Text("Nombre: \(articulo.nombre ?? "No disponible")")
                Text("Cantidad: \(articulo.cantidad)")
                Text("Prioridad: \(articulo.prioridad ?? "No especificada")")
                Text("Notas adicionales: \(articulo.notas ?? "No hay notas")")
            }

            // Sección de categoría y tienda
            Section(header: Text("Categoría y Tienda")) {
                Text("Categoría: \(articulo.categoria ?? "No especificada")")
                Text("Tienda: \(articulo.tienda ?? "No especificada")")
            }

            // Sección de acciones
            Section {
                Button("Editar Artículo") {
                    showEditView = true
                }
                .foregroundColor(.blue)

                Button("Eliminar Artículo") {
                    showDeleteConfirmation = true
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Detalles del Artículo")
        .sheet(isPresented: $showEditView) {
            // Vista de edición de artículo
            EditarArticuloView(articulo: $articulo)
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Eliminar Artículo"),
                message: Text("¿Estás seguro de que deseas eliminar este artículo?"),
                primaryButton: .destructive(Text("Eliminar")) {
                    eliminarArticulo()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationBarItems(trailing: Button("Cerrar") {
            presentationMode.wrappedValue.dismiss()
        })
    }

    // Función para eliminar el artículo
    private func eliminarArticulo() {
        do {
            try CoreDataManagerCompras.shared.eliminarArticulo(articulo: articulo)
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error al eliminar artículo: \(error)")
        }
    }
}
