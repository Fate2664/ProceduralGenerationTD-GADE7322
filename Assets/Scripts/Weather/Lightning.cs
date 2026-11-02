using UnityEngine;

public class Lightning : MonoBehaviour
{
    [SerializeField] private float height = 20f;      
    [SerializeField] private int segments = 12;       
    [SerializeField] private float jaggedness = 1f;  
    [SerializeField] private float lifetime = 0.2f;   
    private LineRenderer line;
    private float startWidth;
    private float timer;

    private void Awake()
    {
        line = GetComponent<LineRenderer>();
        startWidth = line.widthMultiplier;
    }

    public void Strike(Vector3 target)
    {
        Vector3 start = target + Vector3.up * height;
        line.positionCount = segments + 1;

        for (int i = 0; i <= segments; i++)
        {
            float t = (float)i / segments;
            Vector3 point = Vector3.Lerp(start, target, t);

         
            if (i != 0 && i != segments)
            {
                point.x += Random.Range(-jaggedness, jaggedness);
                point.z += Random.Range(-jaggedness, jaggedness);
            }

            line.SetPosition(i, point);
        }

        timer = lifetime;
    }

    private void Update()
    {
        timer -= Time.deltaTime;

        line.widthMultiplier = startWidth * Mathf.Clamp01(timer / lifetime);

        if (timer <= 0f)
            Destroy(gameObject);
    }

}
