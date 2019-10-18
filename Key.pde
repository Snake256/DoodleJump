class Key
{
  private boolean toggled = false;
  
  public boolean IsDown;
  
  public void Toggle(boolean clicked)
  {
    if(clicked != toggled)
    {
      IsDown = clicked;
  
      toggled = !toggled;
    }
    else
    {
      IsDown = false;
    }
  }
}
