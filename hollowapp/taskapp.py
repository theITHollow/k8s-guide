from app import create_app, db, cli
from app.models import User, Post, Task

app = create_app()
cli.register(app)


@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'User': User, 'Post': Post, 'Task' : Task}
